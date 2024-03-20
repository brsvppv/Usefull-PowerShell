# Define function to install service
function New-NssmService {
    param (
        [Parameter(Mandatory)]
        [string]$ServiceName,
        [Parameter(Mandatory)]
        [string]$PSPath,
        [Parameter(Mandatory)]
        [string]$ScriptPath
    )
    Write-Output ServiceName: $ServiceName
    Write-Output ScriptName: $ScriptPath
    Write-Output Powershell: $PSPath
    Write-Host "$PSScriptRoot\nssm-2.24\win64" -ForegroundColor green
    do {
        $confirmation = Read-Host "Continue with installation? (y/n)"
        if ($confirmation.ToLower() -eq 'y') {
            try {
                Set-Location "$PSScriptRoot\nssm-2.24\win64"
                # Attempt to install the service
                ./nssm install "$ServiceName" "$PSPath" "-NoProfile -ExecutionPolicy Bypass -File $ScriptPath"
                break  # Exit the loop if installation is successful
            }
            catch {
                Write-Host "An error occurred during installation: $_"
            }
        }
        elseif ($confirmation.ToLower() -eq 'n') {
            Write-Host "Installation canceled."
            break  # Exit the loop if installation is canceled
        }
        else {
            Write-Host "Invalid input. Please enter 'y' to continue or 'n' to cancel."
        }
    } while ($true)
}
New-NssmService -ServiceName "Test" -ScriptPath "C:\!DO_NOT_DELETE\Automation\myscript.ps1" -PSPath "C:\Program Files\PowerShell\7\pwsh.exe"