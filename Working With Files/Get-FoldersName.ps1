function Get-FolderNames {
    param (
        [string]$path
    )

    # Initialize an empty array
    $directories = @()

    # Check if the provided path exists
    if (-Not (Test-Path -Path $path -PathType Container)) {
        Write-Host "The specified path does not exist or is not a folder." -ForegroundColor Red
        return
    }

    # Get folder names (directories) in the specified path
    $folders = Get-ChildItem -Path $path -Directory
    $directories += $folders.Name

    # Return the folder names as an array
    return $directories
}

# Example usage
$directories = Get-FolderNames -path "\\tvbg\root\nf\office"
$directories
