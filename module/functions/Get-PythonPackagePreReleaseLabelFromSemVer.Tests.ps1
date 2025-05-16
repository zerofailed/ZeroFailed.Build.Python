$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. $here/$sut

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