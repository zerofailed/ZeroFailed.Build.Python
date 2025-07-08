# <copyright file="_runPyTest.ps1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>

<#
.SYNOPSIS
    Invokes the PyTest test runner for a Poetry project.
.DESCRIPTION
    An internal wrapper function that runs PyTest for a Poetry project, which enables the functionality to be wrapped in try/finally block inside the calling task.
.EXAMPLE
    _runPyTest
#>
function _runPyTest
{
    [CmdletBinding()]
    param ($ToolPath, $RunParams = @())

    exec {
        & $ToolPath run @RunParams `
            pytest `
            --cov=$PythonSourceDirectory `
            --cov-report= `
            --cov-append `
            --junitxml=$PyTestResultsPath
    }
}