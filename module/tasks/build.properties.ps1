# <copyright file="build.properties.ps1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>

# Synopsis: When true, the build will assume that Python Poetry is already installed and available in the PATH.
$SkipInstallPythonPoetry = [Convert]::ToBoolean((property ZF_BUILD_PYTHON_SKIP_INSTALL_POETRY $false))

# Synopsis: When true, the build will not run 'poetry install' to initialise the virtual environment.
$SkipInitialisePythonPoetry = [Convert]::ToBoolean((property ZF_BUILD_PYTHON_SKIP_INIT_POETRY $false))

# Synopsis: When truue, the build will not run the flake8 linter.
$SkipRunFlake8 = [Convert]::ToBoolean((property ZF_BUILD_PYTHON_SKIP_RUN_FLAKE8 $false))

# Synopsis: The root path of the Python project. For example, this is used to locate the 'pyproject.toml' file.
$PythonProjectDir = property ZF_BUILD_PYTHON_PROJECT_PATH ""

# Synopsis: The path to where the Python source code is located. Default is "./src" relative to the build script.
$PythonSourceDirectory = property ZF_BUILD_PYTHON_SRC_DIRECTORY "src"

# Synopsis: The path to where Python Poetry is installed. By default the build will attempt to locate it via the PATH environment variable.
$PoetryPath = property ZF_BUILD_PYTHON_POETRY_PATH ((Get-Command poetry -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Path) ?? "")
