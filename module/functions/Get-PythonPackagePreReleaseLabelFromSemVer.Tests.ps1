# <copyright file="Get-PythonPackagePreReleaseLabelFromSemVer.Tests.ps1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>

BeforeAll {
    # sut
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

Describe "Get-PythonPackagePreReleaseLabelFromSemVer Tests" {

    It "Returns empty string for stable versions (empty pre-release label)" {
        $result = Get-PythonPackagePreReleaseLabelFromSemVer -PreReleaseLabel ""
        $result | Should -Be ""
    }

    It "Returns empty string for stable versions (null pre-release label)" {
        $result = Get-PythonPackagePreReleaseLabelFromSemVer -PreReleaseLabel $null
        $result | Should -Be ""
    }

    It "Returns 'rc' for release candidates" {
        $result = Get-PythonPackagePreReleaseLabelFromSemVer -PreReleaseLabel "rc"
        $result | Should -Be "rc"
    }

    It "Returns 'a' for alpha versions (short-form)" {
        $result = Get-PythonPackagePreReleaseLabelFromSemVer -PreReleaseLabel "a"
        $result | Should -Be "a"
    }

    It "Returns 'a' for alpha versions (long-form)" {
        $result = Get-PythonPackagePreReleaseLabelFromSemVer -PreReleaseLabel "alpha"
        $result | Should -Be "a"
    }

    It "Returns 'b' for beta versions (short-form)" {
        $result = Get-PythonPackagePreReleaseLabelFromSemVer -PreReleaseLabel "b"
        $result | Should -Be "b"
    }

    It "Returns 'b' for beta versions (long-form)" {
        $result = Get-PythonPackagePreReleaseLabelFromSemVer -PreReleaseLabel "beta"
        $result | Should -Be "b"
    }

    It "Returns 'a' for PEP440 non-compliant pre-release label" {
        $result = Get-PythonPackagePreReleaseLabelFromSemVer -PreReleaseLabel "feature-mybranch"
        $result | Should -Be "a"
    }
}