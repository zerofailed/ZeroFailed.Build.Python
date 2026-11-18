---
document type: cmdlet
external help file: ZeroFailed.Build.Python-Help.xml
HelpUri: ''
Locale: en-US
Module Name: ZeroFailed.Build.Python
ms.date: 11/18/2026
PlatyPS schema version: 2024-05-01
title: Get-PythonPackagePreReleaseLabelFromSemVer
---

# Get-PythonPackagePreReleaseLabelFromSemVer

## SYNOPSIS

Gets the Python package pre-release label from a semantic versioning (SemVer) string.

## SYNTAX

### __AllParameterSets

```
Get-PythonPackagePreReleaseLabelFromSemVer [-PreReleaseLabel] <string> [<CommonParameters>]
```

## ALIASES

## DESCRIPTION

This function takes a SemVer pre-release label and returns the corresponding PEP440-compliant Python package pre-release label.
It handles the following cases:
- Stable versions (no pre-release label)
- Release candidates ('rc')
- Alpha and Beta versions ('a', 'b')
- Other versions ('a')

## EXAMPLES

### EXAMPLE 1

Get-PythonPackagePreReleaseLabelFromSemVer -PreReleaseLabel "rc"
rc

This command returns 'rc' as the Python package pre-release label for a release candidate version.

### EXAMPLE 2

Get-PythonPackagePreReleaseLabelFromSemVer -PreReleaseLabel "beta"
beta

This command returns 'b' as the Python package pre-release label for a beta version.

## PARAMETERS

### -PreReleaseLabel

The pre-release label from a SemVer string.
This parameter is mandatory but can be an empty string (i.e.
signifying a non-prerelase version).

```yaml
Type: System.String
DefaultValue: ''
SupportsWildcards: false
Aliases: []
ParameterSets:
- Name: (All)
  Position: 0
  IsRequired: true
  ValueFromPipeline: false
  ValueFromPipelineByPropertyName: false
  ValueFromRemainingArguments: false
DontShow: false
AcceptedValues: []
HelpMessage: ''
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable,
-InformationAction, -InformationVariable, -OutBuffer, -OutVariable, -PipelineVariable,
-ProgressAction, -Verbose, -WarningAction, and -WarningVariable. For more information, see
[about_CommonParameters](https://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS

- [PEP 440: Pre-releases](https://peps.python.org/pep-0440/#pre-releases)
