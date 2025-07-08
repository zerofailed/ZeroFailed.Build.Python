# <copyright file="build.tasks.ps1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>

. $PSScriptRoot/build.properties.ps1

# Synopsis: Checks whether Python is installed and available on the PATH environment variable. If not, throws an error.
task EnsurePython -If { $PythonProjectDir -ne "" } {

    if (!(Get-Command python -ErrorAction SilentlyContinue)) {
        throw "A Python installation could not be found. Please install Python and ensure it is available on the PATH environment variable."
    }
}

# Synopsis: Installs Python Poetry if it is not already installed. Poetry is a dependency management tool for Python.
task InstallPythonPoetry -If { !$SkipInstallPythonPoetry } EnsurePython,{

    $existingPoetry = Get-Command poetry -ErrorAction SilentlyContinue
    if (!$existingPoetry -and !$PoetryPath) {       
        # The install script will honour this environment variable. If not explicitly set, we set it to:
        #  - On build servers we install within the working directory to ensure it's part of the build agent caching
        #  - Otherwise, we install to the user profile directory in a cross-platform way
        $env:POETRY_HOME ??= $IsRunningOnBuildServer ? (Join-Path $here ".poetry") : (Join-Path ($IsWindows ? $env:USERPROFILE : $env:HOME) ".poetry")
        $env:POETRY_VERSION = $PythonPoetryVersion
        $poetryBinPath = Join-Path $env:POETRY_HOME "bin"

        # If the poetry binary is not found, install it
        if (!(Test-Path (Join-Path $poetryBinPath "poetry"))) {
            Write-Build White "Installing Poetry $env:POETRY_VERSION: $env:POETRY_HOME"
            Invoke-WebRequest -Uri https://install.python-poetry.org/ -OutFile get-poetry.py
            exec { & python get-poetry.py --yes }
            Remove-Item get-poetry.py -Force
        }
        
        # Ensure the poetry tool is availiable to the rest of the build process
        $script:PoetryPath = Join-Path $poetryBinPath "poetry"
        Write-Build Green "Poetry now available: $PoetryPath"
        if ($poetryBinPath -notin ($env:PATH -split [System.IO.Path]::PathSeparator)) {
            Write-Build White "Adding Poetry to PATH: $poetryBinPath"
            $env:PATH = "$poetryBinPath{0}$env:PATH" -f [System.IO.Path]::PathSeparator
        }
    }
    else {
        if (!$PoetryPath) {
            # Ensure $PoetryPath is set if poetry was already available in the PATH
            $script:PoetryPath = $existingPoetry.Path
        }
        Write-Build Green "Poetry already installed: $PoetryPath"
    }
}

# Synopsis: Updates the Poetry lockfile without updating any packages. This is useful for local development scenarios to ensure that the lockfile is in sync with the pyproject.toml file.
task UpdatePoetryLockfile -If { !$IsRunningOnBuildServer } InstallPythonPoetry,{
    Write-Build White "Ensuring poetry.lock is up-to-date - no packages will be updated"

    # Extract the Poetry version from the output of the --version command
    # Example output: Poetry (version 1.8.0)
    $poetryVersionMsg = & $script:PoetryPath --version
    [semver]$poetryVersion = $poetryVersionMsg.Replace("Poetry (version ", "").Replace(")", "")

    Set-Location $PythonProjectDir
    if ($poetryVersion.Major -lt 2) {
        # Poetry versions less v2.0.0 default to updating package versions
        & $script:PoetryPath update --no-update
    }
    else {
        # Poetry v2 and later will not update package versions by default
        & $script:PoetryPath update
    }
}

# Synopsis: Initialise the Python Poetry virtual environment.
task InitialisePythonPoetry -If { !$SkipInitialisePythonPoetry } InstallPythonPoetry,UpdatePoetryLockfile,{
    if (!(Test-Path (Join-Path $PythonProjectDir "pyproject.toml"))) {
        throw "pyproject.toml not found in $PythonProjectDir"
    }

    # Default to using virtual environments in the project directory, unless already set
    $env:POETRY_VIRTUALENVS_IN_PROJECT ??= "true"

    # Define the global poetry arguments we will use for all poetry commands
    $script:poetryGlobalArgs = @(
        "--no-interaction"
        "--directory=$PythonProjectDir"
        "-v"
    )
    Write-Build White "poetryGlobalArgs: $poetryGlobalArgs"

    exec { & $script:PoetryPath install @poetryGlobalArgs --with dev,test }
}

task InstallPythonUv -If { $SkipInstallPythonPoetry } {

    $existingUv = Get-Command uv -ErrorAction SilentlyContinue
    if (!$existingUv) {
        # If the uv binary is not found, install it
        if (!(Test-Path (Join-Path $uvBinPath "uv"))) {
            Write-Build White "Installing uv $env:UV_VERSION"
            Invoke-RestMethod https://astral.sh/uv/$env:UV_VERSION/install.ps1 | Invoke-Expression
        }

        $uv = Get-Command uv -ErrorAction SilentlyContinue
        $script:PythonUvPath = $uv.Path
        Write-Build Green "uv now available: $PythonUvPath"
    }
    else {
        $script:PythonUvPath = $existingUv.Path
        Write-Build Green "uv already installed: $PythonUvPath"
    }
}

task UpdateUvLockfile -If { !$IsRunningOnBuildServer } InstallPythonUv,{
    Write-Build White "Ensuring uv.lock is up-to-date - no packages will be updated"

    exec { & $script:PythonUvPath lock }
}

task InitialisePythonUv -If { !$SkipInitialisePythonUv } InstallPythonUv,UpdateUvLockfile,{
    if (!(Test-Path (Join-Path $PythonProjectDir "pyproject.toml"))) {
        throw "pyproject.toml not found in $PythonProjectDir"
    }

    exec { & $script:PythonUvPath sync }
}

# Synopsis: Run the flake8 linter on the Python source code.
task RunFlake8 -If { $PythonProjectDir -ne "" -and !$SkipRunFlake8 } InitialisePythonPoetry,{
    Write-Build White "Running flake8"
    # Explicitly change directory as Flake8 does not run when Poetry has the '--directory' argument
    Set-Location $PythonProjectDir
    exec { & $script:PoetryPath run --no-interaction -v flake8 src $PythonFlake8Args }
}

# Synopsis: Runs the Python build process.
task BuildPython -If { $PythonProjectDir -ne "" } -After BuildCore BuildPythonPoetry,BuildPythonUv,RunFlake8

task BuildPythonPoetry -If { $PythonProjectManager -eq "poetry" -and $PythonProjectDir -ne "" } -After BuildCore InitialisePythonPoetry
task BuildPythonUv -If { $PythonProjectManager -eq "uv" -and $PythonProjectDir -ne "" } -After BuildCore InitialisePythonUv
