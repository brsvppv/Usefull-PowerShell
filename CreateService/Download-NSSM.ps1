Function Get-NSSM($Link) {
    Write-Host "Getting Web Response..."
    $WebResponse = Invoke-WebRequest "$Link/download" -UseBasicParsing
    $ZipFiles = $WebResponse.Links |  Where-Object { $_ -like '*/release/*.zip*' }
    Write-Host "Building Download Link"
    $downloadLink = $Link + $ZipFiles.href
    #$FileName = $download_link.Split("/")[-1]
    $fileName = [System.IO.Path]::GetFileName($downloadLink)
    #$download_zip = "{0}/{1}" -f $Link, $archives.href
    $userDownloads = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
    $filePath = Join-Path -Path $userDownloads -ChildPath $FileName
    Write-Host "Initiate Downloading...`nPlease Wait"
    Invoke-WebRequest -Uri $downloadLink -OutFile $filePath -ErrorAction Stop
    Write-Host "Download Finished"
    #return $filePath
    Write-Host "Extracting the archive to the current path"
    Expand-Archive -Path $filePath -DestinationPath $PSScriptRoot
    Write-Output "Cleaning up...($filePath)"
    Remove-Item -Path $filePath -Force

}

Get-NSSM('https://nssm.cc/')


