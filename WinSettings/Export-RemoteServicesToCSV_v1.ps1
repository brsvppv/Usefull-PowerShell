Function Export-RemoteServicesToCSV {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$FilePath = $env:TEMP, # Default path if no path provided

        [Parameter()]
        [string]$FileName = (New-Guid),

        [Parameter()]
        [string]$ComputerName = $env:COMPUTERNAME  # Default to the local computer
    )
    $ErrorActionPreference = 'STOP'
    # Combine the file path and file name
    $FullPath = Join-Path -Path $FilePath -ChildPath $FileName

    # Create a temporary file
    $tempFile = [System.IO.Path]::GetTempFileName() + ".csv"

    try {
        # Retrieve services from the specified computer
        if ($ComputerName -eq $env:COMPUTERNAME) {
            $Services = Get-Service | Select-Object Status, Name, DisplayName
        }
        else {
            $Services = Invoke-Command -ComputerName $ComputerName -ScriptBlock {
                Get-Service | Select-Object Status, Name, DisplayName
            }
        }

        # Create a custom object for each service to include the Status as an integer
        $ServicesWithStatusInt = $Services | ForEach-Object {
            [PSCustomObject]@{
                Name        = $_.Name
                DisplayName = $_.DisplayName
                Status      = $_.Status.ToString()
                StatusInt   = [int]$_.Status
            }
        }

        # Export the custom objects to the temporary CSV file
        $ServicesWithStatusInt | Export-Csv -Path $tempFile -NoTypeInformation

        # Ensure the directory exists
        if (-not (Test-Path -Path $FilePath)) {
            New-Item -Path $FilePath -ItemType Directory -Force | Out-Null
        }

        # Move the temporary file to the desired location
        Move-Item -Path $tempFile -Destination $FullPath -Force

        Write-Output "Services exported to $FullPath"
    }
    catch {
        Write-Output "Failed to retrieve or export services: $_"
    }
}

# Example usage
Export-RemoteServicesToCSV -ComputerName "MachineName" -FilePath "C:\TEMP\servces\" -FileName 'BDTVSO06_v1.csv'