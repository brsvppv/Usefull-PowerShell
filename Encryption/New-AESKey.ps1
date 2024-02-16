function New-AESKey() {
    Param(
        [Parameter(Mandatory = $false, Position = 1, ValueFromPipeline = $true)]
        [Int]$KeySize = 256
    )
    try {
        $AESProvider = New-Object "System.Security.Cryptography.AesManaged"
        $AESProvider.KeySize = $KeySize
        $AESProvider.GenerateKey()
        return [System.Convert]::ToBase64String($AESProvider.Key)
    }
    catch {
        Write-Error $_
    }
}

$Key = New-AESKey
Write-Output $Key