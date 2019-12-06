$ErrorActionPreference = 'stop'
Set-StrictMode -Version latest

$RepoRoot = (Resolve-Path $PSScriptRoot\..).Path

Describe 'Text files formatting' {
    
    $allTextFiles = Get-ChildItem $RepoRoot -Exclude ignored | % {
        Get-ChildItem -file -recurse $_ -Exclude *.dll
    }
    
    Context 'Files encoding' {

        It "Doesn't use Unicode encoding" {
            $allTextFiles | %{
                $path = $_.FullName
                $bytes = [System.IO.File]::ReadAllBytes($path)
                $zeroBytes = @($bytes -eq 0)
                if ($zeroBytes.Length) {
                    Write-Warning "File $($_.FullName) contains 0 bytes. It's probably uses Unicode and need to be converted to UTF-8"
                }
                $zeroBytes.Length | Should Be 0
            }
        }
    }

    Context 'Indentations' {

        It "We are using spaces for indentaion, not tabs" {
            $totalTabsCount = 0
            $allTextFiles | %{
                $fileName = $_.FullName
                Get-Content $_.FullName -Raw | Select-String "`t" | % {
                    Write-Warning "There are tab in $fileName"
                    $totalTabsCount++
                }
            }
            $totalTabsCount | Should Be 0
        }
    }
}
