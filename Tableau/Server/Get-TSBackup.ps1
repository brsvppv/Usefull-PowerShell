function Get-TSBackup {
    [CmdletBinding()]
    param(
        # Parameter help description
        [Parameter(Mandatory)][Alias('TargeDirectory')]
        [string]$Destination,
        [Parameter(Mandatory)][Alias('File')]
        [string]$FileName
    )
    try {
        # Set error action preference to Stop
        $ErrorActionPreference = 'Stop'
        $timestamp = Get-Date -Format "yyyyMMddHHmmss"
        #$FileName = [string]::Format("{0}{1}", $FileName,'.tsbak')
        #Check if destination path exist if not create.
        If (!(Test-Path($Destination))) { New-Item -Path $Destination -ItemType Directory }
        #Get Tableau Backup File Path
        $backupFilePath = tsm configuration get -k basefilepath.backuprestore

        #Get Arhived and Export Logs Path
        $logArchiveFiles = tsm configuration get -k basefilepath.log_archive

        # Define file paths
        $FullSourceTsbakFilePath = Join-Path -Path $backupFilePath -ChildPath "$FileName.tsbak"
        $fullSourceArchivePath = Join-Path -Path $logArchiveFiles -ChildPath "logs.zip"
        $jsonSettingsExportPath = Join-Path -Path $Destination -ChildPath "$FileName.json"
        
        #Create Tableau Zip Log Archivev
        tsm maintenance ziplogs -all
        #Create Tableau Data Backup tsbak format
        tsm maintenance backup -f "$FileName.tsbak"
        #export tableau json settings
        tsm settings export --output-config-file $jsonSettingsExportPath
        #cleanup tableau
        tsm maintenance cleanup -l --log-files-retention 7

        #Move Tableau Backup to the Destination Locaiton
        Move-Item -Path $FullSourceTsbakFilePath -Destination "$Destination\$FileName.tsbak"
        #Move Tableau logs to the Destination Location
        Move-Item -Path $FullSourceArchivePath -Destination "$Destination\$FileName.zip"

        $FileArchive = ("{0}\{1}-{2}-TBS.zip" -f $Destination, $timestamp, $ENV:COMPUTERNAME)
        #Comporess File into single archive 
        #Compress-Archive "$Destination\*" -CompressionLevel Optimal -Update -DestinationPath "$FileArchive" -ErrorAction Stop
        $compress = @{
            Path             = "$Destination\$FileName.tsbak", "$Destination\$FileName.zip", "$jsonSettingsExportPath"
            CompressionLevel = "Optimal"
            Update           = $true
            DestinationPath  = "$FileArchive"
        }
        Compress-Archive @compress -ErrorAction Stop
        $isSuccess = $true
    }
    catch {
        $isSuccess = $false
        Write-Host "ERROR: $_"
    }
    finally {
        #reset the action perference
        $ErrorActionPreference = 'Continue'
        if ($isSuccess) {
            $filesToRemove = @("$Destination\$FileName.tsbak", "$Destination\$FileName.zip", "$jsonSettingsExportPath")
            # Remove the files
            Remove-Item -Path $filesToRemove -Verbose
        }
        else {
            Write-Host "Archive is not created, check the tableau files in $Destination "
        } 
    }
    $Info = [PSCustomObject]@{
        FileArchive = $FileArchive
        Success     = $isSuccess
    }
    return $Info
}


$Backup = New-Backup -Destination 'C:\Backup' -FileName "TableauBackup"
$Backup.Info

