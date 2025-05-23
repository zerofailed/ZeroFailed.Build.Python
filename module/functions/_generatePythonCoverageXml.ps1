# <copyright file="_generatePythonCoverageXml.ps1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>

<#
.SYNOPSIS
    Invokes the Python code coverage report generator.
.DESCRIPTION
    An internal wrapper function that runs Python code coverage report generator.
.EXAMPLE
    _generatePythonCoverageXml
#>
function _generatePythonCoverageXml
{
    [CmdletBinding()]
    param ()

    exec {
        & $script:PoetryPath run `
            coverage `
            xml `
            -o $PythonCoverageReportPath
    }
}