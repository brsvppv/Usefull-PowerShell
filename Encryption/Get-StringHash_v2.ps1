function Get-StringHash {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$StringToHash
    )

    # Get bytes
    [byte[]]$hashText = [System.Text.Encoding]::UTF8.GetBytes($StringToHash)
        
    # Instantiate hash algorithm
    $textHasher = [System.Security.Cryptography.SHA256Managed]::new()
        
    # Compute hash
    [byte[]]$hashByteArray = $textHasher.ComputeHash($hashText)
        
    # Convert bytes to hexadecimal string
    $hexHash = $hashByteArray | ForEach-Object { $_.ToString("x2") }

    return $hexHash -join ''
}

$Hash = Get-StringHash -StringToHash "InputTheStringYouWantToHash"
Write-Output $Hash