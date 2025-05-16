# <copyright file="package.properties.ps1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>

# Synopsis: When true, the build will not produce any Python packages.
$SkipBuildPythonPackages = [Convert]::ToBoolean((property ZF_BUILD_PYTHON_SKIP_BUILD_PACKAGES $false))

# Synopsis: When true, the build will not publish Python packages.
$SkipPublishPythonPackages = [Convert]::ToBoolean((property ZF_BUILD_PYTHON_SKIP_PUBLISH_PACKAGES $false))

# Synopsis: The username to use when publishing packages to the Python repository.
$PythonPublishUsername = property ZF_BUILD_PYTHON_PROJECT_PUBLISH_USERNAME "user"

# Synopsis: The logical name to associate with the Python repository where packages will be published.
$PythonPackageRepositoryName = property ZF_BUILD_PYTHON_PUBLISH_REPOSITORY_NAME "ci-python-feed"

# Synopsis: The URL to use when publishing packages to the Python repository.
$PythonPackageRepositoryUrl = property ZF_BUILD_PYTHON_PUBLISH_REPOSITORY_URL ""      # e.g. https://pkgs.dev.azure.com/myOrg/Project/_packaging/myfeed/pypi/upload

# Synopsis: 
$PythonPackagePreReleaseTag = property ZF_BUILD_PYTHON_PUBLISH_PRERELEASE_TAG ""

# Synopsis: The wildcard pattern used to select the built Python packages for publishing. Default is "*.whl".
$PythonPackagesFilenameFilter = property ZF_BUILD_PYTHON_PUBLISH_PACKAGES_FILTER "*.whl"

# Synopsis: When true, the build will use an existing Azure CLI connection to authenticate when publishing Python packages to Azure Artifacts.
$UseAzCliAuthForAzureArtifacts = [Convert]::ToBoolean((property ZF_BUILD_PYTHON_PUBLISH_USE_AZCLI_AUTH $false))
