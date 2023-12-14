using namespace System.Security.Cryptography;

class CryptoRandom : Random {
    [RandomNumberGenerator] $RNG

    CryptoRandom() {
        $this.RNG = [RandomNumberGenerator]::Create()
    }

    [void] NextBytes([byte[]] $Buffer) {
        $this.RNG.GetBytes($Buffer)
    }

    [double] NextDouble() {
        $Buffer = [byte[]]::new(4)
        $this.NextBytes($Buffer);

        return [BitConverter]::ToUInt32($Buffer, 0) / [double][UInt32]::MaxValue;
    }

    [int] Next([int] $MinValue, [int] $MaxValue) {
        if ($MinValue -lt 0) {
            throw [ArgumentOutOfRangeException]("MinValue must be 0 or greater. Received $MinValue.");
        }

        if ($MaxValue -lt 0) {
            throw [ArgumentOutOfRangeException]("MaxValue must be 0 or greater. Received $MaxValue.");
        }

        if ($MinValue -gt $MaxValue) {
            throw [ArgumentOutOfRangeException]("MinValue must be less than NaxValue. Received $MinValue and $MaxValue.")
        }

        if ($MinValue -eq $MaxValue) {
            return $MinValue
        }

        $Range = $MaxValue - $MinValue;
        
        return [int]([Math]::Floor($this.NextDouble() * $Range) + $MinValue)
    }

    [int] Next() {
        return $this.Next(0, [int]::MaxValue);
    }

    [int] Next([int] $MaxValue) {
        if ($MaxValue -lt 0) {
            throw [ArgumentOutOfRangeException]("MaxValue must be greater than zero. Received $MaxValue.");
        }

        return $this.Next(0, $MaxValue);
    }
}
