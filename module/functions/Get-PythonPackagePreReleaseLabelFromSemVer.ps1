# <copyright file="Get-PythonPackagePreReleaseLabelFromSemVer.ps1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>

<#
.SYNOPSIS
    Gets the Python package pre-release label from a semantic versioning (SemVer) string.
.DESCRIPTION
    This function takes a SemVer pre-release label and returns the corresponding PEP440-compliant Python package pre-release label.
    It handles the following cases:
    - Stable versions (no pre-release label)
    - Release candidates ('rc')
    - Alpha and Beta versions ('a', 'b')
    - Other versions ('a')
.PARAMETER PreReleaseLabel
    The pre-release label from a SemVer string. This parameter is mandatory but can be an empty string (i.e. signifying a non-prerelase version).
.EXAMPLE
    PS> Get-PythonPackagePreReleaseLabelFromSemVer -PreReleaseLabel "rc"
    rc

    This command returns 'rc' as the Python package pre-release label for a release candidate version.
.EXAMPLE
    PS> Get-PythonPackagePreReleaseLabelFromSemVer -PreReleaseLabel "beta"
    beta

    This command returns 'b' as the Python package pre-release label for a beta version.
#>
function Get-PythonPackagePreReleaseLabelFromSemVer
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [AllowEmptyString()]
        [string] $PreReleaseLabel
    )

    switch ($PreReleaseLabel) {

        # Stable versions have no pre-release label
        {[string]::IsNullOrEmpty($PreReleaseLabel)} {
            return ""
        }
        
        # Release candidates have a pre-release label of 'rc'
        "rc" {
            return "rc"
        }
        
        # Poetry accepts certain long-form pre-release labels and will convert them to short-form,
        # but it is useful to be explicit about the short-form label so the version is consistent
        # for other parts of the build process and other tools 
        {$_ -in "alpha","beta"} {
            return $_[0]
        }
        
        # Beta versions have a pre-release label of 'b'
        "b" {
            return "b"
        }
        
        # If the pre-release label is not recognised, default to 'a' (alpha)
        default {
            return "a"
        }
    }
}