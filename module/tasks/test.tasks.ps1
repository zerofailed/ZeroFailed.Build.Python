# <copyright file="test.tasks.ps1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>

. $PSScriptRoot/test.properties.ps1

# Synopsis: Runs any PyTest and/or Behave tests in the Python source code.
task RunPythonTests -If { $PythonProjectDir -ne "" || ($SkipRunPyTest && $SkipRunBehave) } -After TestCore InitialisePythonPoetry,{

    Write-Build White "Removing previous Python coverage results"
    # Explicitly change directory as 'coverage erase' does not run when Poetry has the '--directory' argument
    Set-Location $PythonProjectDir

    if ($PythonProjectManager -eq "uv") {
        $toolPath = $script:PythonUvPath
    }
    elseif ($PythonProjectManager -eq "poetry") {
        $toolPath = $script:PoetryPath
    }

    exec { & $toolPath run coverage erase }

    $pythonTestErrors = @()
    try {
        try {
            if (!$SkipRunPyTest) {
                Write-Build White "Running PyTest..."

                if ($PythonProjectManager -eq "uv") {
                    $runParams = @()
                }
                elseif ($PythonProjectManager -eq "poetry") {
                    $runParams = @(
                        "--no-interaction"
                        "-v"
                    )
                }
                _runPyTest $toolPath $runParams
            }
        }
        catch {
            Write-Error $_ -ErrorAction Continue
            $pythonTestErrors += "PyTest Errors, check previous output for details"
        }

        try {
            if (!$SkipRunBehave) {
                Write-Build White "Running Behave..."
                _runBehave $toolPath
            }
        }
        catch {
            Write-Error $_ -ErrorAction Continue
            $pythonTestErrors += "Behave Errors, check previous output for details"
        }
    }
    finally {
        Write-Build White "Generating Python coverage report"
        _generatePythonCoverageXml $toolPath

        if ($pythonTestErrors) {
            $pythonTestsErrorMsg = "{0}{1}" -f [Environment]::NewLine, ($pythonTestErrors -join [Environment]::NewLine) 
            throw $pythonTestsErrorMsg
        }
    }
}
