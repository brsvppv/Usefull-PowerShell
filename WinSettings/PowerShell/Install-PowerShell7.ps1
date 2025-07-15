#https://api.github.com/repos/PowerShell/PowerShell/releases/latest
Function Install-PwSh7msix {
    $pwsh = (Invoke-Expression "pwsh --version" -ErrorAction SilentlyContinue)
    $downloads_path = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
    $latest = Invoke-RestMethod -Uri "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
    #$info_msi = ($latest.assets | Where-Object { $_.name -like "*win-x64.msi" }).browser_download_url
    $info_msix = ($latest.assets | Where-Object { $_.name -like "*.msixbundle" })
    write-host $info_msix.name
    write-host $info_msix.browser_download_url
    $fileName = Join-Path -Path $downloads_path -ChildPath $info_msix.name

    if (!($pwsh)) {
        try {
            Start-BitsTransfer -Source $info_msix.browser_download_url -Destination $downloads_path -TransferType Download -Priority Foreground -ErrorAction Stop
            Write-Host "Download Finished" -ForegroundColor Green            
        }
        catch {
            Write-Error $_ | Out-File "$env:TEMP\pwshdownload.log" -Force
            return 
        }
        Write-Host 'Starting installtion' -ForegroundColor Yellow
        try {

            Add-AppPackage -Path $fileName -force
        }
        catch {
            Write-Error $_ | Out-File "$env:TEMP\pwshdownload.log" -Force
            return 
        }
        write-host "Installation Finished" -ForegroundColor Green
    }
    exit
}#https://api.github.com/repos/PowerShell/PowerShell/releases/latest
Install-PwSh7msix