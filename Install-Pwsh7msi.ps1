#https://api.github.com/repos/PowerShell/PowerShell/releases/latest
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$IsAdmin = [Security.Principal.WindowsIdentity]::GetCurrent()
If ((New-Object Security.Principal.WindowsPrincipal $IsAdmin).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) -eq $FALSE) {
    # ReLunch With Admin Rights
    # Create a new process object that starts PowerShell
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe";
    # Specify the current script path and name as a parameter
    $newProcess.Arguments = $myInvocation.MyCommand.Definition;
    # Indicate that the process should be elevated
    $newProcess.Verb = "runas";
    #hidden pws
    #$newProcess.WindowStyle = "Hidden"
    # Start the new process
    [System.Diagnostics.Process]::Start($newProcess);
    # Exit from the current, unelevated, process
    exit
}
Function Install-PwSh7msi {
    $pwsh = (Invoke-Expression "pwsh --version" -ErrorAction SilentlyContinue | Out-null)
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
        Write-Host 'Starting installtion' -ForegroundColor Yellow
        try {
            $exitCode = (Start-Process "msiexec.exe" -ArgumentList "/i $fileName", "/qn", "ADD_EXPLORER_CONTEXT_MENU_OPENPOWERSHELL=1 ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1 ENABLE_PSREMOTING=1 REGISTER_MANIFEST=1 USE_MU=1 ENABLE_MU=1 ADD_PATH=1" -Wait -PassThru).ExitCode 
        }
        catch {
            Write-Error $_ | Out-File "$env:TEMP\pwshdownload.log" -Force
            return 
        }
        Finally {
            Write-Host "Installation Finished with code:  $exitCode" -ForegroundColor Green
            if ($exitCode -eq 0) {
                Remove-Item $fileName -Force
            }
        }
    }
}
#https://api.github.com/repos/PowerShell/PowerShell/releases/latest
Install-PwSh7msi