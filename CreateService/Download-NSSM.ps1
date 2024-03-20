Function Get-NSSM($Link) {
    $WebResponse = Invoke-WebRequest "$Link/download" # | Where-Object { $_ -like '*.zip*' }
    $ZipFiles = $WebResponse.Links |  Where-Object { $_ -like '*/release/*.zip*' }
    
    $downloadLink = $Link + $ZipFiles.href
    #$FileName = $download_link.Split("/")[-1]
    $fileName = [System.IO.Path]::GetFileName($downloadLink)
    #$download_zip = "{0}/{1}" -f $Link, $archives.href
    $userDownloads = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
    
    $filePath = Join-Path -Path $userDownloads -ChildPath $FileName

    Invoke-WebRequest -Uri $downloadLink -OutFile $filePath -ErrorAction Stop
    return $filePath

}

$file = Get-NSSM('https://nssm.cc/')

Expand-Archive -Path $file -DestinationPath $PSScriptRoot
#Get Link in the HTML for realsed version
# $ReleasedVersions = $WebResponse.Links
# $ReleasedVersions