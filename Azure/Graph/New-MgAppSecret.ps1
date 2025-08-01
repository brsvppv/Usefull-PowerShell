function New-MgAppSecret {
<#
    .SYNOPSIS
    Creates a new Azure AD application secret and exports the details to a CSV file.

    .DESCRIPTION
    This script requires the Microsoft Graph PowerShell module (`Microsoft.Graph`) to be installed and imported.
    You can install it using: Install-Module Microsoft.Graph -Scope CurrentUser

    .PARAMETER AppObjectId
    The ObjectId of the Azure AD Application.

    .PARAMETER Years
    Number of years the secret will be valid.

    .PARAMETER OutputCsv
    Output CSV file path for storing the secret details (default: .\AppSecrets.csv).
#>

    [CmdletBinding()]
    param (
        # The ObjectId of the Azure AD Application
        [Parameter(Mandatory)]
        [string]$AppObjectId,

        # Number of years the secret will be valid
        [Parameter(Mandatory)]
        [int]$Years,

        # Output CSV file path for storing the secret details
        [Parameter()]
        [string]$OutputCsv = ".\AppSecrets.csv"
    )

    # Ensure connection to Microsoft Graph
    if (-not (Get-MgContext)) {
        Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
        Connect-MgGraph -Scopes 'Application.ReadWrite.All'
    }

    # Prepare the password credential object
    $passwordCred = @{
        displayName = "App Secret via PowerShell"
        endDateTime = (Get-Date).AddYears($Years)
    }

    try {
        # Create the new application secret
        $secret = Add-MgApplicationPassword -ApplicationId $AppObjectId -PasswordCredential $passwordCred
    } catch {
        Write-Error "Failed to create the application secret: $_"
        return
    }

    # Prepare the object for export
    $exportObject = [PSCustomObject]@{
        Timestamp     = (Get-Date)
        AppObjectId   = $AppObjectId
        SecretName    = $passwordCred.displayName
        Expires       = $passwordCred.endDateTime
        SecretText    = $secret.SecretText
        SecretId      = $secret.KeyId
    }

    try {
        # Ensure the output directory exists
        $directory = Split-Path -Path $OutputCsv
        if (-not (Test-Path -Path $directory)) {
            New-Item -Path $directory -ItemType Directory -Force | Out-Null
        }

        # Export the secret details to CSV (append if file exists)
        $fileExists = Test-Path $OutputCsv
        $exportObject | Export-Csv -Path $OutputCsv -Append:($fileExists) -NoTypeInformation
        Write-Host "✅ Secret created and saved to $OutputCsv" -ForegroundColor Green
    } catch {
        Write-Error "Failed to export secret to CSV: $_"
    }
}

# Example usage: create a new secret for the given AppObjectId, valid for 10 years, and export to user's profile
New-MgAppSecret -AppObjectId '7e0264d9-53a6-44d2-a48d-0f67122b9f63' -Years 10 -OutputCsv "$env:USERPROFILE\AppSecrets.csv"