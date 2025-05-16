# <copyright file="package.tasks.ps1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>

. $PSScriptRoot/package.properties.ps1

# Synopsis: Build Python packages using Poetry. This task will build the packages and place them in the 'dist' directory.
task BuildPythonPackages -If { $PythonProjectDir -ne "" -and !$SkipBuildPythonPackages } Version,EnsurePackagesDir,InitialisePythonPoetry,{
    if (Test-Path (Join-Path $PythonProjectDir "dist")) {
        Remove-Item (Join-Path $PythonProjectDir "dist") -Recurse -Force
    }

    # Apply python pre-release versioning conventions
    # Ideally the repo will have a GitVersion configuration such that:
    #  - The master/main branch has a pre-release tag of 'rc' (release candidate)
    #  - All other branches have a pre-release tag of 'b' (beta)
    #  - Tagged commits have no pre-release tag

    # However, as a fallback we must ensure that we always have a PEP440 compliant pre-release tag
    # even if GitVersion does not
    $safePreReleaseLabel = Get-PythonPackagePreReleaseLabelFromSemVer -PreReleaseLabel $GitVersion.PreReleaseLabel

    $PythonPackagePreReleaseTag = [string]::IsNullOrEmpty($PythonPackagePreReleaseTag) ? ("{0}{1}" -f $safePreReleaseLabel, $GitVersion.PreReleaseNumber) : $PythonPackagePreReleaseTag
    $pythonPackageVersion = "$($GitVersion.MajorMinorPatch)$PythonPackagePreReleaseTag"

    Write-Build White "Building Python packages with version: $pythonPackageVersion"
    exec { & $script:PoetryPath version @poetryGlobalArgs $pythonPackageVersion }
    # Make the Python package version available to the rest of the build, since it could be different to the GitVersion
    Set-BuildServerVariable -Name "PythonPackageVersion" -Value $pythonPackageVersion

    # Build the package(s)
    # For the moment we live with the fact that Poetry's output path is not configurable
    exec { & $script:PoetryPath build @poetryGlobalArgs }
}

# Synopsis: Publishes the built Python packages to the specified repository.
task PublishPythonPackages -If { $PythonProjectDir -ne "" -and !$SkipPublishPythonPackages } InitialisePythonPoetry,{

    # Copy the Python packages from the standard packaging output folder to where Poetry expects to find them
    $distPath = Join-Path $PythonProjectDir "dist"
    $pythonPackages = gci $distPath/$PythonPackagesFilenameFilter

    if (!$pythonPackages ) {
        Write-Warning "No Python packages found, skipping publish"
    }
    elseif (!$PythonPackageRepositoryUrl) {
        Write-Warning "PythonPackageRepositoryUrl build variable not set, skipping publish"
    }
    elseif (!$UseAzCliAuthForAzureArtifacts -and !$env:PYTHON_PACKAGE_REPOSITORY_KEY) {
        Write-Warning "PYTHON_PACKAGE_REPOSITORY_KEY environment variable not set, skipping publish"
    }
    else {
        Write-Build White "Registering Python repository $PythonPackageRepositoryName -> $PythonPackageRepositoryUrl"
        exec {
            & $script:PoetryPath config @poetryGlobalArgs repositories.$PythonPackageRepositoryName $PythonPackageRepositoryUrl
        }

        if ($UseAzCliAuthForAzureArtifacts) {
            Write-Build White "Requesting Azure DevOps access token via Azure CLI..."

            $env:PYTHON_PACKAGE_REPOSITORY_KEY = _getAccessTokenForAzureArtifacts
            if ($LASTEXITCODE -ne 0) {
                throw "Failed to retrieve Azure DevOps access token via Azure CLI"
            }
        }

        Write-Build White "Publishing Python packages to $PythonPackageRepositoryName"
        exec {
            _runPoetryPublish
        }
    }
}
