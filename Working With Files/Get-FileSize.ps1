function Get-FileSize {
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateScript({
                if (Test-Path $_ -PathType Leaf) { $true }
                else { throw "File Path '$_' does not exist or is not a file" }
            })]
        [string]$Path
    )
    try {
        # Get file size
        $fileInfo = Get-Item $Path
        $byteSize = $fileInfo.Length
        # Check if file size is greater than zero
        if ($byteSize -gt 0) {
            # Format file size
            if ($byteSize -gt 1TB) { return "{0:N2} TB" -f ($byteSize / 1TB) }
            elseif ($byteSize -gt 1GB) { return "{0:N2} GB" -f ($byteSize / 1GB) }
            elseif ($byteSize -gt 1MB) { return "{0:N2} MB" -f ($byteSize / 1MB) }
            elseif ($byteSize -gt 1KB) { return "{0:N2} KB" -f ($byteSize / 1KB) }
            else { return "{0} Bytes" -f $byteSize }
        }
        else {
            return "File size is zero Bytes"
        }
    }
    catch {
        throw "Error occurred while retrieving file size: $_"
    }
}
$fileSize = Get-FileSize -Path "Drive:\Path\File.extension"
write-host $fileSize