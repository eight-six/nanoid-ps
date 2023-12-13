Import-Module (Join-Path $PSScriptRoot '..' '..' 'src' 'nanoid-ps') -Verbose -Force

$global:DefaultAlphabet = '-0123456789abcdefghijklmnopqrstuvwxyz_ABCDEFGHIJKLMNOPQRSTUVWXYZ'
$global:DefaultSize = 21

Describe 'New-NanoId' {
    It 'should return a string' {
        $Id = New-NanoId
        $Id | Should -BeOfType [string]
    }

    It "should return a string of length $global:DefaultSize" {
        $Id = New-NanoId
        $Id.Length | Should -Be $global:DefaultSize
    }

    It 'should return a string containing only characters from the default alphabet' {
        $Id = New-NanoId
        $Id | Should -Match "^[$global:DefaultAlphabet]{$global:DefaultSize}$"
    }

    It 'should return a string of length 10' {
        $Id = New-NanoId -Size 10
        $Id.Length | Should -Be 10
    }

    It 'should return a string of length 10 with custom alphabet' {
        $Id = New-NanoId -Size 10 -Alphabet '1234567890'
        $Id.Length | Should -Be 10
    }

    It 'should return only return characters from a custom alphabet (lowercase only)' {
        $Id = New-NanoId -Size 10 -Alphabet 'abcdefghijklmnopqrstuvwxyz'
        Write-Verbose "id: $Id" -Verbose
        $Id | Should -Match '^[a-z]{10}$'
    }

    It 'should return only return characters from a custom alphabet (uppercase only)' {
        $Id = New-NanoId -Size 10 -Alphabet 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        Write-Verbose "id: $Id" -Verbose
        $Id | Should -Match '^[A-Z]{10}$'
    }

    It 'should return only return characters from a custom alphabet (numbers only)' {
        $Id = New-NanoId -Size 10 -Alphabet '0123456789'
        Write-Verbose "id: $Id" -Verbose
        $Id | Should -Match '^[0-9]{10}$'
    }

    It 'should not have collisions' {
        $Ids = @()
        $Iterations = 1000000

        1..$Iterations | ForEach-Object {
            $Id = New-NanoId
            $Ids += $Id
        }
       
        $Ids | Select-Object -Unique | Measure-Object | Select-Object -exp Count | Should -Be $Iterations
    }

}