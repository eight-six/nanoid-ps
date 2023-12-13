using namespace System.Numerics

$ErrorActionPreference = 'Stop'

[string] $DefaultAlphabet = '_-0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
[CryptoRandom] $Random = [CryptoRandom]::new()

function New-NanoId {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Random]$Random = $script:Random, 
        [ValidateNotNullOrEmpty()]
        [string] $Alphabet = $script:DefaultAlphabet, 
        [ValidateRange(1, 255)]
        [int] $Size = 21) 

    if ($Alphabet.Length -le 0 -or $Alphabet.Length -ge 256) {
        throw [ArgumentOutOfRangeException]("Alphabet must contain between 1 and 255 symbols. Received $($Alphabet.Length) chars.");
    }

    # See https://github.com/ai/nanoid/blob/master/format.js for explanation why masking
    # is used (`random % alphabet` is a common mistake security-wise).
    $Mask = (2 -shl 31 - [BitOperations]::LeadingZeroCount(($Alphabet.Length - 1) -bor 1)) - 1
    $Step = [int][Math]::Ceiling(1.6 * $Mask * $Size / $Alphabet.Length)
    Write-Verbose "Step: $Step" #-Verbose
    $IdBuilder = [char[]]::new($Size)
    $Buffer = [byte[]]::new($Step)
    $cnt = 0;
    
    for ($cnt; $cnt -lt $size ; $cnt++ ) {
        $Random.NextBytes($Buffer);

        for ($i = 0; $i -lt $Step; $i++) {
            $AlphabetIndex = $Buffer[$i] -band $Mask;

            if ($AlphabetIndex -ge $Alphabet.Length) { 
                continue
            }

            $IdBuilder[$cnt] = $Alphabet[$AlphabetIndex]
        }
    }

    $RetVal = [string]::new($IdBuilder)
    Write-Verbose "NanoId: $RetVal" #-Verbose
    return $RetVal
}
