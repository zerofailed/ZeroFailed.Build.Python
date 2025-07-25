# <copyright file="test.properties.ps1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>

# Synopsis: When true, the build will not run any PyTest tests.
$SkipRunPyTest = [Convert]::ToBoolean((property ZF_BUILD_PYTHON_SKIP_RUN_PYTEST $false))

# Synopsis: When true, the build will not run any Behave tests.
$SkipRunBehave = [Convert]::ToBoolean((property ZF_BUILD_PYTHON_SKIP_RUN_BEHAVE $false))

# Synopsis: The path where the PyTest test results XML file will be written.
$PyTestResultsPath = property ZF_BUILD_PYTHON_PYTEST_RESULTS_PATH (Join-Path $here "pytest-test-results.xml")

# Synopsis: The path where the Behave test results XML file will be written.
$BehaveResultsPath = property ZF_BUILD_PYTHON_BEHAVE_RESULTS_PATH (Join-Path $here "behave-test-results.xml")

# Synopsis: The path where the Python code coverage XML report will be written.
$PythonCoverageReportPath = property ZF_BUILD_PYTHON_COVERAGE_REPORT_PATH (Join-Path $CoverageDir "coverage.xml")
