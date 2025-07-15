# Install-Pwsh7msiRemote.ps1
# Remotely installs the latest PowerShell 7 MSI on one or more servers using PowerShell Remoting

function Install-PwSh7msiRemote {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]]$ComputerName,
        [pscredential]$Credential
    )
    $scriptBlock = {
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $pwsh = Get-Command pwsh -ErrorAction SilentlyContinue
        $downloads_path = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
        $latest = Invoke-RestMethod -Uri "https://api.github.com/repos/PowerShell/PowerShell/releases/latest"
        $info_msi = ($latest.assets | Where-Object { $_.name -like "*win-x64.msi" })
        $fileName = Join-Path -Path $downloads_path -ChildPath $info_msi.name
        if (!($pwsh)) {
            try {
                Start-BitsTransfer -Source $info_msi.browser_download_url -Destination $downloads_path -TransferType Download -Priority Foreground -ErrorAction Stop
                Write-Host "Download Finished" -ForegroundColor Green            
            }
            catch {
                Write-Error $_ | Out-File "$env:TEMP\pwshdownload.log" -Force
                return 
            }
            Write-Host 'Starting installation' -ForegroundColor Yellow
            try {
                Start-Process "msiexec.exe" -ArgumentList "/i $fileName", "/qn", "ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1 USE_MU=1 ENABLE_MU=1 ADD_PATH=1" -WindowStyle Hidden
            }
            catch {
                Write-Error $_ | Out-File "$env:TEMP\pwshdownload.log" -Force
                return  
            }
            Finally {
                Write-Host "Installation triggered. The session may disconnect if the installer restarts PowerShell." -ForegroundColor Green
            }
        }
    }
    $job = Invoke-Command -ComputerName $ComputerName -ScriptBlock $scriptBlock -Credential $Credential -AsJob
    Write-Host "Started remote install job. Waiting for completion..." -ForegroundColor Cyan
    Wait-Job $job
    $output = Receive-Job $job
    Write-Host "Remote install job completed. Output:" -ForegroundColor Cyan
    $output
    Remove-Job $job
}

<#
Usage example:
    . .\Install-Pwsh7msiRemote.ps1
    Install-PwSh7msiRemote -ComputerName 'server1','server2' -Credential (Get-Credential)
#>

Install-PwSh7msiRemote -ComputerName 'VRTVSO03' -Credential (Get-Credential)