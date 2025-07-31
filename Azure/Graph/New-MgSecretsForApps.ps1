function New-MgSecretsForApps {
<#
.SYNOPSIS
Creates new secrets for all Azure AD applications with a specified prefix and exports the details to a CSV file.

.DESCRIPTION
Requires the Microsoft Graph PowerShell module (`Microsoft.Graph`). 
Connects to Microsoft Graph, finds all applications whose DisplayName starts with the given prefix, creates a new secret for each, and exports the secret details.

.PARAMETER Prefix
The prefix to filter application DisplayNames (default: "tv_").

.PARAMETER Years
Number of years the secret will be valid (default: 1).

.PARAMETER OutputCsv
Path to the output CSV file (default: C:\Temp\AppSecrets.csv).
#>
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$Prefix,

        [Parameter()]
        [int]$Years = 1,

        [Parameter()]
        [string]$OutputCsv = (Join-Path $env:USERPROFILE "ExistingApps.csv")
    )

    # Ensure Graph connection
    if (-not (Get-MgContext)) {
        Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
        Connect-MgGraph -Scopes 'Application.ReadWrite.All'
    }

    # Get applications that start with specified prefix
    Write-Host "🔍 Searching for applications starting with '$Prefix'..." -ForegroundColor Cyan
    $filter = "startsWith(DisplayName,'$Prefix')"
    $apps = Get-MgApplication -Filter $filter

    if (-not $apps) {
        Write-Warning "No applications found with prefix '$Prefix'"
        return
    }

    # Prepare output array
    $appSecrets = @()

    foreach ($app in $apps) {
        Write-Host "🔐 Creating secret for: $($app.DisplayName)" -ForegroundColor Yellow

        $passwordCred = @{
            displayName = "App Secret for $Years years created for $($app.DisplayName)"
            endDateTime = (Get-Date).AddYears($Years)
        }

        try {
            $secret = Add-MgApplicationPassword -ApplicationId $app.Id -PasswordCredential $passwordCred

            $appSecrets += [PSCustomObject]@{
                Timestamp     = Get-Date
                AppId         = $app.AppId
                AppObjectId   = $app.Id
                DisplayName   = $app.DisplayName
                SecretId      = $secret.KeyId
                SecretValue   = $secret.SecretText
                Expires       = $passwordCred.endDateTime
            }
        } catch {
            Write-Error "Failed to create secret for app: $($app.DisplayName) - $_"
        }
    }

    # Export to CSV
    try {
        $directory = Split-Path -Path $OutputCsv
        if (-not (Test-Path $directory)) {
            New-Item -Path $directory -ItemType Directory -Force | Out-Null
        }

        $appSecrets | Export-Csv -Path $OutputCsv -NoTypeInformation -Force
        Write-Host "✅ Secrets saved to: $OutputCsv" -ForegroundColor Green
    } catch {
        Write-Error "❌ Failed to export to CSV: $_"
    }
}
#example name:myapp_test using the prefix myapp_)
New-MgSecretsForApps -Prefix "myapp_" -Years 3 -OutputCsv "C:\Exports\MyAppSecrets.csv"