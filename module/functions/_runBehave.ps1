# <copyright file="_runBehave.ps1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>

<#
.SYNOPSIS
    Invokes the Behave test runner for a Poetry project.
.DESCRIPTION
    An internal wrapper function that runs PyTest for a Poetry project, which enables the functionality to be wrapped in try/finally block inside the calling task.
.EXAMPLE
    _runBehave
#>
function _runBehave
{
    [CmdletBinding()]
    param ($ToolPath)

    $testReportsPath = (Join-Path $here "behave-test-reports-temp")
    if (Test-Path $testReportsPath) {
        Remove-Item -Path $testReportsPath -Recurse -Force
    }

    New-Item -Path $testReportsPath -ItemType Directory | Out-Null

    try {
        exec {
            & $ToolPath run `
                coverage `
                run `
                --append `
                --source=$PythonSourceDirectory `
                --omit= `
                --include= `
                -m behave `
                --junit `
                --junit-directory $testReportsPath
        }
    }
    finally {
        exec {
            & $ToolPath run junitparser merge --glob $testReportsPath/*.xml $BehaveResultsPath
        }
    }
}