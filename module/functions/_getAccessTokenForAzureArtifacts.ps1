# <copyright file="_getAccessTokenForAzureArtifacts.ps1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>

<#
.SYNOPSIS
    An internal wrapper function that uses Azure CLI to get an Azure Artifacts access token.
.DESCRIPTION
    An internal wrapper function that uses an existing Azure CLI connection to obtain an access token for
    Azure Artifacts and can be mocked in tests.
.EXAMPLE
    _getAccessTokenForAzureArtifacts
#>
function _getAccessTokenForAzureArtifacts
{
    [CmdletBinding()]
    param ()
    
    & az account get-access-token `
            --resource '499b84ac-1321-427f-aa17-267ca6975798' `
            --query 'accessToken' `
            --output tsv
}