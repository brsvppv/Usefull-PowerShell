function Stop-BulkServerServices {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$ServiceName,

        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [string[]]$DisplayNameStartsWith
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
        else {
            # Default: Get all services if no filter is provided
            Write-Host "Please provide service to stop"
        }

        foreach ($service in $services) {
            $serviceName = $service.Name
            $displayName = $service.DisplayName

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
    }
}
Stop-BulkServerServices -ServiceName 'MSSQLSERVER', 'SQLSERVERAGENT'
Stop-BulkServerServices -DisplayNameStartsWith 'SQL Server'