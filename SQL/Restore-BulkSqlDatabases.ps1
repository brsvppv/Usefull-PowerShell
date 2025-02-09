function Invoke-BulkSqlDbsRestore {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$SQLServer,
        [Parameter()]
        [string]$Instance,
        [Parameter(Mandatory)]
        [string]$FilesPath,
        [Parameter(Mandatory)]
        [string]$DbsPath,
        [Parameter(Mandatory)]
        [string]$LogsPath
    )
    if (!(Get-Module -ListAvailable -Name SQLPS)) {
        Install-Module -Name SqlServer
    }
    try {
        Import-Module SQLPS

        if ($Instance) {
            $SQLServer = "{0}\{1}" -f $SQLServer, $Instance
        }
        write-host $SQLServer -ForegroundColor Green

        $dbfiles = Get-ChildItem -Path $FilesPath -Filter "*FULL.bak"

        foreach ($dbfile in $dbfiles) {
            write-host "Restoring $($dbfile.FullName)" -ForegroundColor Yellow
            
            # Use a connection string with TrustServerCertificate=True
            $connectionString = "Server=$SQLServer;Integrated Security=True;TrustServerCertificate=True"
            
            # Get backup header information
            $HeadersInfo = Invoke-Sqlcmd -ConnectionString $connectionString -Query "RESTORE HEADERONLY FROM DISK = N'$($dbfile.FullName)'"
            
            # Get file list information
            $BackupInfo = Invoke-Sqlcmd -ConnectionString $connectionString -Query "RESTORE FILELISTONLY FROM DISK = N'$($dbfile.FullName)'"

            # Create an array to hold RelocateFile objects
            $RelocateFiles = @()
            foreach ($file in $BackupInfo) {
                $LogicalName = $file.LogicalName
                $PhysicalName = $file.PhysicalName
                $FileType = $file.Type

                # Determine the new path based on file type
                if ($FileType -eq 'D') {
                    # Data file
                    $NewPhysicalName = Join-Path -Path $DbsPath -ChildPath (Split-Path -Leaf $PhysicalName)
                }
                elseif ($FileType -eq 'L') {
                    # Log file
                    $NewPhysicalName = Join-Path -Path $LogsPath -ChildPath (Split-Path -Leaf $PhysicalName)
                }
                else {
                    # Unknown file type (handle as needed)
                    $NewPhysicalName = $PhysicalName
                }
                
                # Create a RelocateFile object
                $RelocateFile = New-Object Microsoft.SqlServer.Management.Smo.RelocateFile($LogicalName, $NewPhysicalName)
                $RelocateFiles += $RelocateFile
            }
            # Restore the database
            Restore-SqlDatabase -ServerInstance $SQLServer -Database $HeadersInfo.DatabaseName -BackupFile $dbfile.FullName -RelocateFile $RelocateFiles
        }
    }
    catch {
        Write-host "ERROR $_"
    }
}

Invoke-BulkSqlDbsRestore -SQLServer 'DBTVSO01' -Instance 'SQL2012' -FilesPath 'C:\TEMP_BACKUP\2012' -DbsPath "D:\DBS_2012" -LogsPath "L:\LOGS_2012"