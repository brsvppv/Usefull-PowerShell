function Start-BulkServerServices {
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
            $services = Get-Service
        }

        foreach ($service in $services) {
            $serviceName = $service.Name
            $displayName = $service.DisplayName

            Write-Host "🚀 Starting service: $displayName ($serviceName)"
            try {
                if ($service.Status -ne 'Running') {
                    Start-Service -Name $($serviceName).ToString() -ErrorAction Stop
                    Write-Host "✅ Successfully started: $displayName"
                }
                else {
                    Write-Host "⚠️ Service already running: $displayName"
                }

                # Set startup type to Automatic
                Set-Service -Name $($serviceName).ToString() -StartupType Automatic -ErrorAction Stop
                Write-Host "🔧 Set startup type to Automatic for: $displayName"
            }
            catch {
                Write-Host "❗ Error handling service $displayName $($_.Exception.Message)"
            }
        }
    }
}
Start-BulkServerServices -DisplayNameStartsWith 'Microsoft Dynamics NAV Server'