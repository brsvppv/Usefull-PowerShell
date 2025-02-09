# Define the output CSV file
$outputFile = "C:\TEMP\SQL_Database_Report.csv"

# Initialize an empty array to store the results
$databaseInfo = @()

# Read server instances from file
foreach ($instance in Get-Content "C:\Path\To\InstanceList\SQLInstances.txt") {
    
    # Load SQL Server SMO library
    [System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | Out-Null

    # Create an SMO connection to the instance
    $server = New-Object ('Microsoft.SqlServer.Management.Smo.Server') $instance
    $dbs = $server.Databases

    # Process each database, excluding system databases
    foreach ($db in $dbs | Where-Object { $_.Name -notin @("master", "model", "msdb", "tempdb") }) {
        $databaseInfo += [PSCustomObject]@{
            "Instance Name"       = $instance
            "Database Name"       = $db.Name
            "Collation"           = $db.Collation
            "Compatibility Level" = $db.CompatibilityLevel
            "AutoShrink"          = $db.AutoShrink
            "Recovery Model"      = $db.RecoveryModel
            "Size (GB)"           = [Math]::Round($db.Size / 1024, 2)
            "Size (MB)"           = [Math]::Round($db.Size)
        }
    }
}

# Export data to CSV
$databaseInfo | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8

Write-Output "Export completed: $outputFile"
