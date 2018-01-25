Import-Module $PSScriptRoot\..\ZLocation\ZLocation.Storage.psm1 -Force

Describe 'ZLocation.Storage' {

    $originalCount = (Get-ZLocation).Count

    try {

        $path = [guid]::NewGuid().Guid
        $path2 = [guid]::NewGuid().Guid

        It 'can add weight' {
            $w1 = 6.6
            $w2 = 10.0
            Add-ZWeight -path $path -weight $w1
            $h = Get-ZLocation
            $h.Count | Should Be ($originalCount + 1)
            $h[$path] | Should Be $w1

            Add-ZWeight -path $path -weight $w2
            $h = Get-ZLocation
            $h.Count | Should Be ($originalCount + 1)
            $h[$path] | Should Be ($w1 + $w2)
        }

        It 'can add another path' {
            Add-ZWeight -path $path2 -weight 1.0
            $h = Get-ZLocation
            $h.Count | Should Be ($originalCount + 2)
        }

        It 'can filter paths' {
            $h = Get-ZLocation -Match $path2.Substring(0,5)
            $path | Should -Not -BeIn $h.Keys # Fails in Pester 3 - no BeIn
            $path2 | Should -BeIn $h.Keys # Fails in Pester 3 - no BeIn
        }

        It 'can filter paths with multiple filters' {
            $h = Get-ZLocation -Match $path2.Substring(0,5),$path.Substring(0,5)
            $path | Should -BeIn $h.Keys # Fails in Pester 3 - no BeIn
            $path2 | Should -BeIn $h.Keys # Fails in Pester 3 - no BeIn
        }

    } finally {

        It 'can remove path' {
            Remove-ZLocation -path $path2
            $h = Get-ZLocation
            $h.Count | Should Be ($originalCount + 1)

            Remove-ZLocation -path $path
            $h = Get-ZLocation
            $h.Count | Should Be $originalCount
        }

    }
}
