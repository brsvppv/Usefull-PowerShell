function Compress-7ZipArchive {
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, Position = 0)]
        [System.String]
        $Source,

        [Parameter(Mandatory , Position = 1)]
        [System.String]
        $Destination,

        [Parameter(Position = 2)]
        [SecureString]
        $Password,

        [Parameter(Mandatory, Position = 4)]
        [System.String]
        [ValidateSet('7z', 'zip', 'gzip', 'bzip2', 'tar')]
        $ArchiveType,

        [Parameter(Mandatory, Position = 5)]
        [System.String]
        $ZIPPath
    )

    if (!(Test-Path $ZIPPath)) { throw '7ZIP could not be found' }
    
    #Creating arguments for archive creation
    $arguments = "a -t$ArchiveType ""$Destination"" ""$Source"" -mx9"
    
    if ($PassKey) {
        $PassKey = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password))
        $arguments += " -p$PassKey" 
    }

    $ZipUp = Start-Process $ZIPPath -ArgumentList $arguments -Wait -PassThru -WindowStyle Normal 
    if ($ZipUp.ExitCode -EQ 0) { Write-Output "Archive has been created successfully" }
    elseif ($ZipUp.ExitCode -ne 0) { Write-Error 'Archive Failed' }

}

Compress-7ZipArchive -Source 'A:\!TestDirectory\Source' -Destination 'A:\!TestDirectory\Target'  -ArchiveType '7z' -ZIPPath 'C:\Program Files\7-Zip\7z.exe'