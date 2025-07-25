Function Export-ServicesToCSV {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$CsvPath
    )
    $Services = Get-Service | Select-Object Status, Name, DisplayName

    # Create a custom object for each service to include the Status as an integer
    $ServicesWithStatusInt = $Services | ForEach-Object {
        [PSCustomObject]@{
            Name        = $_.Name
            DisplayName = $_.DisplayName
            Status      = $_.Status.ToString()
            StatusInt   = [int]$_.Status
        }
    }

    # Export the custom objects to a CSV file
    $ServicesWithStatusInt | Export-Csv -Path $CsvPath -NoTypeInformation

    Write-Output "Services exported to $CsvPath"
}

Export-ServicesToCSV -csvPath "C:\Temp\services.csv"