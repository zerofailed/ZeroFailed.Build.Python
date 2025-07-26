# ZeroFailed.Build.Python - Reference Sheet

<!-- START_GENERATED_HELP -->

## Build
 
This group contains functionality for using the Poetry & UV dependency management tools with Python projects.

### Properties

| Name                         | Default Value         | ENV Override                          | Description                                                                                                                     |
| ---------------------------- | --------------------- | ------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------- |
| `PoetryInstallArgs`          | @()                   |                                       | Array of the default arguments passed to 'poetry install', override to customise its behaviour.                                 |
| `PoetryInstallCicdArgs`      | @("--without", "dev") |                                       | Array of the arguments passed to 'poetry install' when running on CI/CD servers, override to customise its behaviour.           |
| `PoetryPath`                 | ""                    | `ZF_BUILD_PYTHON_POETRY_PATH`         | The path to where Python Poetry is installed. By default the build will attempt to locate it via the PATH environment variable. |
| `PythonFlake8Args`           | "-v"                  |                                       | The arguments passed to the Python flake8 linter, override to customise its behaviour.                                          |
| `PythonPoetryVersion`        | ""                    | `POETRY_VERSION`                      | The version of Python Poetry to install, if not already available.                                                              |
| `PythonProjectDir`           | ""                    | `ZF_BUILD_PYTHON_PROJECT_PATH`        | The root path of the Python project. For example, this is used to locate the 'pyproject.toml' file.                             |
| `PythonProjectManager`       | "poetry"              | `ZF_BUILD_PYTHON_PROJECT_MANAGER`     | The project/package manager to use for the Python project. Supported values are "poetry" or "uv".                               |
| `PythonSourceDirectory`      | "src"                 | `ZF_BUILD_PYTHON_SRC_DIRECTORY`       | The path to where the Python source code is located.                                                                            |
| `PythonUvVersion`            | ""                    | `ZF_BUILD_PYTHON_UV_VERSION`          | The version of uv to use for the build. Default is the latest version.                                                          |
| `SkipInitialisePythonPoetry` | $false                | `ZF_BUILD_PYTHON_SKIP_INIT_POETRY`    | When true, the build will not run 'poetry install' to initialise the virtual environment.                                       |
| `SkipInitialisePythonUv`     | $false                | `ZF_BUILD_PYTHON_SKIP_INIT_UV`        | When true, the build will not run 'uv sync' to initialise the virtual environment.                                              |
| `SkipInstallPythonPoetry`    | $false                | `ZF_BUILD_PYTHON_SKIP_INSTALL_POETRY` | When true, the build will assume that Python Poetry is already installed and available in the PATH.                             |
| `SkipInstallPythonUv`        | $false                | `ZF_BUILD_PYTHON_SKIP_INSTALL_UV`     | When true, the build will assume that Python uv is already installed and available in the PATH.                                 |
| `SkipRunFlake8`              | $false                | `ZF_BUILD_PYTHON_SKIP_RUN_FLAKE8`     | When true, the build will not run the flake8 linter.                                                                            |
| `UvSyncArgs`                 | @("--all-groups")     |                                       | Array of the default arguments passed to 'uv sync', override to customise its behaviour.                                        |
| `UvSyncCicdArgs`             | @("--no-dev")         |                                       | Array of the arguments passed to 'uv sync' when running on CI/CD servers, override to customise its behaviour.                  |

### Tasks

| Name                     | Description                                                                                                                                                                    |
| ------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `BuildPython`            | Wrapper task for the overall Python build process.                                                                                                                             |
| `BuildPythonPoetry`      | Wrapper task for the Poetry-based build process.                                                                                                                               |
| `BuildPythonUv`          | Wrapper task for the UV-based build process.                                                                                                                                   |
| `EnsurePython`           | Checks whether Python is installed and available on the PATH environment variable. If not, throws an error.                                                                    |
| `InitialisePythonPoetry` | Initialise the Python Poetry virtual environment.                                                                                                                              |
| `InitialisePythonUv`     | Initialise the UV virtual environment.                                                                                                                                         |
| `InstallPythonPoetry`    | Installs Python Poetry if it is not already installed. Poetry is a dependency management tool for Python.                                                                      |
| `InstallPythonUv`        | Installs UV if it is not already installed. UV is a dependency management tool for Python.                                                                                     |
| `RunFlake8`              | Run the flake8 linter on the Python source code.                                                                                                                               |
| `UpdatePoetryLockfile`   | Updates the Poetry lockfile without updating any packages. This is useful for local development scenarios to ensure that the lockfile is in sync with the pyproject.toml file. |
| `UpdateUvLockfile`       | Updates the UV lockfile without updating any packages. This is useful for local development scenarios to ensure that the lockfile is in sync with the pyproject.toml file.     |

## Package

This group contains functionality for using the Poetry & UV tools to build & publish Python `.whl` packages.

### Properties

| Name                            | Default Value    | ENV Override                               | Description                                                                                                                                    |
| ------------------------------- | ---------------- | ------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| `PythonPackagePreReleaseTag`    | ""               | `ZF_BUILD_PYTHON_PUBLISH_PRERELEASE_TAG`   | Set this to override the default pre-release tag generated by GitVersion.                                                                      |
| `PythonPackageRepositoryName`   | "ci-python-feed" | `ZF_BUILD_PYTHON_PUBLISH_REPOSITORY_NAME`  | The logical name to associate with the Python repository where packages will be published.                                                     |
| `PythonPackageRepositoryUrl`    | ""               | `ZF_BUILD_PYTHON_PUBLISH_REPOSITORY_URL`   | The URL to use when publishing packages to the Python repository.  e.g. https://pkgs.dev.azure.com/myOrg/Project/_packaging/myfeed/pypi/upload |
| `PythonPackagesFilenameFilter`  | "*.whl"          | `ZF_BUILD_PYTHON_PUBLISH_PACKAGES_FILTER`  | The wildcard pattern used to select the built Python packages for publishing.                                                                  |
| `PythonPublishUsername`         | "user"           | `ZF_BUILD_PYTHON_PROJECT_PUBLISH_USERNAME` | The username to use when publishing packages to the Python repository.                                                                         |
| `SkipBuildPythonPackages`       | $false           | `ZF_BUILD_PYTHON_SKIP_BUILD_PACKAGES`      | When true, the build will not produce any Python packages.                                                                                     |
| `SkipPublishPythonPackages`     | $false           | `ZF_BUILD_PYTHON_SKIP_PUBLISH_PACKAGES`    | When true, the build will not publish Python packages.                                                                                         |
| `UseAzCliAuthForAzureArtifacts` | $false           | `ZF_BUILD_PYTHON_PUBLISH_USE_AZCLI_AUTH`   | When true, the build will use an existing Azure CLI connection to authenticate when publishing Python packages to Azure Artifacts.             |

### Tasks

| Name                    | Description                                                                                                         |
| ----------------------- | ------------------------------------------------------------------------------------------------------------------- |
| `BuildPythonPackages`   | Build Python packages using Poetry or UV. This task will build the packages and place them in the 'dist' directory. |
| `PublishPythonPackages` | Publishes the built Python packages to the specified repository.                                                    |

## Test

This group contains functionality for running tests using the [PyTest](https://docs.pytest.org/en/stable/) and/or [Behave](https://behave.readthedocs.io/en/stable/) testing frameworks, as well as collecting code coverage metrics using [Coverage.py](https://coverage.readthedocs.io/en/7.10.0/).

### Properties

| Name                       | Default Value                 | ENV Override                           | Description                                                         |
| -------------------------- | ----------------------------- | -------------------------------------- | ------------------------------------------------------------------- |
| `BehaveResultsPath`        | "./behave-test-results.xml"   | `ZF_BUILD_PYTHON_BEHAVE_RESULTS_PATH`  | The path where the Behave test results XML file will be written.    |
| `PyTestResultsPath`        | "./pytest-test-results.xml"   | `ZF_BUILD_PYTHON_PYTEST_RESULTS_PATH`  | The path where the PyTest test results XML file will be written.    |
| `PythonCoverageReportPath` | "`$CoverageDir`/coverage.xml" | `ZF_BUILD_PYTHON_COVERAGE_REPORT_PATH` | The path where the Python code coverage XML report will be written. |
| `SkipRunBehave`            | $false                        | `ZF_BUILD_PYTHON_SKIP_RUN_BEHAVE`      | When true, the build will not run any Behave tests.                 |
| `SkipRunPyTest`            | $false                        | `ZF_BUILD_PYTHON_SKIP_RUN_PYTEST`      | When true, the build will not run any PyTest tests.                 |

### Tasks

| Name             | Description                                                    |
| ---------------- | -------------------------------------------------------------- |
| `RunPythonTests` | Runs any PyTest and/or Behave tests in the Python source code. |


<!-- END_GENERATED_HELP -->
