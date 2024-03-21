Function Get-NSSM($Link) {
    Write-host "Getting Web Response..."
    $WebResponse = Invoke-WebRequest "$Link/download" -UseBasicParsing
    $ZipFiles = $WebResponse.Links |  Where-Object { $_ -like '*/release/*.zip*' }
    Write-host "Building Download Link"
    $downloadLink = $Link + $ZipFiles.href
    #$FileName = $download_link.Split("/")[-1]
    $fileName = [System.IO.Path]::GetFileName($downloadLink)
    #$download_zip = "{0}/{1}" -f $Link, $archives.href
    $userDownloads = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
    $filePath = Join-Path -Path $userDownloads -ChildPath $FileName
    Write-host "Initiate Downloading...`nPlease Wait"
    Invoke-WebRequest -Uri $downloadLink -OutFile $filePath -ErrorAction Stop
    Write-host "Download Finished"
    return $filePath

}

$file = Get-NSSM('https://nssm.cc/')
$file 
Write-Output "Extracting the archive to the current path"
Expand-Archive -Path $file -DestinationPath $PSScriptRoot
Write-Output "Cleaning up...($file)"
Remove-Item -Path $file -Force

Pause