function WindowsDefender {
    param (
        [string]$Action = "on" # Accepts "on" or "off"
    )

    # Check if running with admin privileges
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
        Write-Error "You need to run this script as an administrator."
        exit
    }

    switch ($Action.ToLower()) {
        "off" {
            # Disable Windows Defender
            Set-MpPreference -DisableRealtimeMonitoring $true
        }
        "on" {
            # Enable Windows Defender

            # Enable Windows Defender real-time protection
            Set-MpPreference -DisableRealtimeMonitoring $false

        }
        default {
            Write-Error "Invalid action specified. Use 'on' or 'off'."
        }
    }
}
WindowsDefender -Action "on"
