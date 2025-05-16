# <copyright file="_runPoetryPublish.ps1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>

<#
.SYNOPSIS
    An internal wrapper function that runs 'poetry publish' and can be mocked in tests.
.DESCRIPTION
    An internal wrapper function that runs 'poetry publish' and can be mocked in tests.
.EXAMPLE
    _runPoetryPublish
#>

function _runPoetryPublish
{
    [CmdletBinding()]
    param ()
    
    & $script:PoetryPath `
        publish `
        @poetryGlobalArgs `
        -u $PythonPublishUser `
        -p $env:PYTHON_PACKAGE_REPOSITORY_KEY `
        -r $PythonRepositoryName
}