function Set-BulkServerServices {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$ServiceName,

        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$DisplayNameStartsWith,

        [Parameter(Mandatory = $true)]
        [ValidateSet('Start', 'Stop')]
        [string]$Action
    )

    process {
        if ($ServiceName) {
            # Filter by Service Name
            $services = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
        }
        elseif ($DisplayNameStartsWith) {
            # Filter by Display Name (partial match)
            $services = Get-Service | Where-Object { $_.DisplayName -like "$DisplayNameStartsWith*" }
        }

        foreach ($service in $services) {
            $serviceName = $service.Name
            $displayName = $service.DisplayName

            if ($Action -eq 'Stop') {
                Write-Host "🛑 Stopping service: $displayName ($serviceName)"
                try {
                    if ($service.Status -ne 'Stopped') {
                        Stop-Service -Name $serviceName -Force -ErrorAction Stop
                        Write-Host "✅ Successfully stopped: $displayName"
                    }
                    else {
                        Write-Host "⚠️ Service already stopped: $displayName"
                    }

                    # Set startup type to Manual
                    Set-Service -Name $serviceName -StartupType Manual
                    Write-Host "🔧 Set startup type to Manual for: $displayName"
                }
                catch {
                    Write-Host "❗ Error handling service $displayName $($_.Exception.Message)"
                }
            }
            elseif ($Action -eq 'Start') {
                Write-Host "🚀 Starting service: $displayName ($serviceName)"
                try {
                    if ($service.Status -ne 'Running') {
                        Start-Service -Name $serviceName -ErrorAction Stop
                        Write-Host "✅ Successfully started: $displayName"
                    }
                    else {
                        Write-Host "⚠️ Service already running: $displayName"
                    }

                    # Set startup type to Automatic
                    Set-Service -Name $serviceName -StartupType Automatic
                    Write-Host "🔧 Set startup type to Automatic for: $displayName"
                }
                catch {
                    Write-Host "❗ Error handling service $displayName $($_.Exception.Message)"
                }
            }
        }
    }
}


# Stop specific services by name
Set-BulkServerServices -ServiceName 'MSSQLSERVER', 'SQLSERVERAGENT' -Action Stop

# Start services by DisplayName (partial match)
Set-BulkServerServices -DisplayNameStartsWith 'Windows Update' -Action Start