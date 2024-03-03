function Invoke-WingetCheck.ps1 {
    # Check if winget is already installed
    $wingetVersion = (Invoke-Expression "winget -v" -ErrorAction SilentlyContinue)
    if ($wingetVersion) {
        Write-Host "Winget Version $wingetVersion is already installed" -ForegroundColor Green
        return  
    }

    # Retrieve latest release information from GitHub API
    $latestRelease = Invoke-RestMethod -Uri 'https://api.github.com/repos/microsoft/winget-cli/releases/latest'

    # Extract download URL for the latest release MSIX bundle
    $downloadUrl = ($latestRelease.assets | Where-Object { $_.name -like "*.msixbundle" }).browser_download_url

    # Define output path for downloaded MSIX bundle
    $outputPath = "$env:TEMP\winget-latest.msixbundle"

    # Download winget MSIX bundle
    Write-Host "Downloading winget..."
    try {
        Invoke-WebRequest -Uri $downloadUrl -OutFile $outputPath -ErrorAction Stop
        Write-Host "Download completed successfully." -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to download winget: $_" -ForegroundColor Red
        return
    }

    # Install winget MSIX bundle
    Write-Host "Installing Winget Package..."
    try {
        Add-AppxPackage -Path $outputPath -ErrorAction Stop
        Write-Host "Winget installed successfully." -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to install winget: $_" -ForegroundColor Red
        return
    }

    # Cleanup downloaded MSIX bundle
    Write-Host "Cleaning up..."
    Remove-Item $outputPath -ErrorAction SilentlyContinue
}