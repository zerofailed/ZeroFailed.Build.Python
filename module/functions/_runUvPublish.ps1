# <copyright file="_runUvPublish.ps1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>

<#
.SYNOPSIS
    An internal wrapper function that runs 'uv publish' and can be mocked in tests.
.DESCRIPTION
    An internal wrapper function that runs 'uv publish' and can be mocked in tests.
.EXAMPLE
    _runUvPublish
#>

function _runUvPublish
{
    [CmdletBinding()]
    param ()
    
    & $script:UvPath `
        publish `
        @uvGlobalArgs `
        -u $script:PythonPublishUsername `
        -p $env:PYTHON_PACKAGE_REPOSITORY_KEY `
        ---publish-url $script:PythonPackageRepositoryUrl
}