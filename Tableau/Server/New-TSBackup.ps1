Function Start-TSBackup {
    #Create Temp Directory to store the backup files
    $DirectoryID = ([Guid]::NewGuid().ToString())
    $DirectoryPath = Join-Path -Path $env:TEMP -ChildPath $DirectoryID
    #### Set Format Date for naming files folders #DateFormatTimeStamp DirectroyName"
    $dateAndtime = (Get-Date).ToString("yyyy-MM-dd-HHmmss")
    #Create Directory
    If (!(Test-Path $DirectoryPath)) { New-Item -Path $DirectoryPath -ItemType Directory }
    #Get TSBK file Location
    $backupfilepath = tsm configuration get -k basefilepath.backuprestore
    ####Get Logs Location:
    $ZipLogsPath = tsm configuration get -k basefilepath.log_archive
    ####Get Default Export Settings Location
    $JsonSettingsPath = tsm configuration get -k basefilepath.site_export.exports
    ####BackupName File Name
    $backupName = "$dateAndtime" + "-" + "$env:COMPUTERNAME"
    ####CreateTimestamp Directory
    Try {
        ####createTableauBackup
        tsm maintenance backup -f $backupName    
        ####zip Server Logs
        tsm maintenance ziplogs -all
        #Export Site Settings Configuration
        tsm settings export -f "$DirectoryPath\$backupName-Settings.json"
        #####Moving the new backup ot the created directory above
        Move-Item -Path "$backupfilepath\$backupName.tsbak" -Destination "$DirectoryPath" -ErrorAction Stop
        ####move the logs to the prearchive directory
        Move-Item -Path "$ZipLogsPath\logs.zip" -Destination "$DirectoryPath\$backupName-logs.zip" -ErrorAction SilentlyContinue
        #Cleanup Tableau Server
        tsm maintenance cleanup
        #Set name for the zip archive
        $ZipArchive = Join-Path -Path $DirectoryPath -ChildPath "$backupName.zip"
        Compress-Archive "$DirectoryPath\*" -CompressionLevel Optimal -Update -DestinationPath $ZipArchive -ErrorAction Stop
        #Backup Succesfull True
        $backup_successful = $true
        $itemsToRemove = @(
            "$DirectoryPath\$backupName.tsbak",
            "$DirectoryPath\$backupName-Settings.json"
            "$DirectoryPath\$backupName-logs.zip"
        )
        # Remove all items in the array
        Remove-Item -Path $itemsToRemove -Recurse -Force
    }
    catch {
        $ErrorMsg = $_.Exception.Message
        $backup_successful = $false
        Write-Host $ErrorMsg
    }
    finally {
        Write-Host "Backup Successful: $backup_successful"
    }
}
Start-TSBackup


