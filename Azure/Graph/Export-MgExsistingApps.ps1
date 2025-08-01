function Export-MgExistingApps {
<#
    .SYNOPSIS
    Exports Azure AD applications, optionally filtered by prefix, to a CSV file.

    .DESCRIPTION
    Requires the Microsoft Graph PowerShell module (`Microsoft.Graph`). 
    Connects to Microsoft Graph, finds all applications (optionally filtered by DisplayName prefix), and exports their basic details to a CSV file.

    .PARAMETER Prefix
    (Optional) The prefix to filter application DisplayNames. If not specified, exports all applications.

    .PARAMETER OutputCsv
    Path to the output CSV file (default: $env:USERPROFILE\ExistingApps.csv).

    .EXAMPLE
    Export-MgExistingApps -Prefix "myapp_" -OutputCsv "C:\Temp\ExistingApps.csv"
    Export-MgExistingApps -OutputCsv "C:\Temp\AllApps.csv"
#>
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Prefix,

        [Parameter()]
        [string]$OutputCsv = (Join-Path $env:USERPROFILE "ExistingApps.csv")
    )

    # Ensure Graph connection
    if (-not (Get-MgContext)) {
        Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
        Connect-MgGraph -Scopes 'Application.Read.All'
    }

    # Build filter if prefix is provided
    if ($Prefix) {
        Write-Host "🔍 Searching for applications starting with '$Prefix'..." -ForegroundColor Cyan
        $filter = "startsWith(DisplayName,'$Prefix')"
        $apps = Get-MgApplication -Filter $filter
    } else {
        Write-Host "🔍 Exporting ALL applications..." -ForegroundColor Cyan
        $apps = Get-MgApplication -All
    }

    if (-not $apps) {
        $msg = "No applications found"
        if ($Prefix) { $msg += " with prefix '$Prefix'" }
        Write-Warning $msg
        return
    }

    $export = @()
    foreach ($app in $apps) {
        $export += [PSCustomObject]@{
            Timestamp   = Get-Date
            AppId       = $app.AppId
            ObjectId    = $app.Id
            DisplayName = $app.DisplayName
        }
    }

    try {
        $directory = Split-Path -Path $OutputCsv
        if (-not (Test-Path $directory)) {
            New-Item -Path $directory -ItemType Directory -Force | Out-Null
        }
        $export | Export-Csv -Path $OutputCsv -NoTypeInformation -Force
        Write-Host "✅ Applications exported to: $OutputCsv" -ForegroundColor Green
    } catch {
        Write-Error "❌ Failed to export to CSV: $_"
    }
}

# Example usage:
Export-MgExistingApps -OutputCsv "C:\Temp\ExistingApps.csv"      # All apps
# Export-MgExistingApps -Prefix "myapp_" -OutputCsv "C:\Temp\MyAppApps.csv"  # Only apps with prefix myapp_