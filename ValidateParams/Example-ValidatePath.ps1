Function Example-ValidatePath {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)][Alias('Destination')]
        [ValidateScript({
                if (!($_ | Test-Path -PathType Container)) {
                    throw "Invalid directory path: $($_.Exception.Message)"
                }
                return $true
            })]
        [System.IO.DirectoryInfo]$CopyTo
    )
}
Example-ValidatePath -CopyTo "TEST"