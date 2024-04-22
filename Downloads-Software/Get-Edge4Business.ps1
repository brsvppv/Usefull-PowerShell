#https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/f626650a-cf6a-4f73-ab30-3889c621001f/MicrosoftEdgeEnterpriseX64.msi
if (Get-Command -Name New-TemporaryFile -ErrorAction SilentlyContinue) {
    $tmp = New-TemporaryFile | Rename-Item -NewName { $_ -replace 'tmp$', 'msi' } -PassThru
}
else {
    $tmp = New-Item -Path $env:TEMP -Name ([System.IO.Path]::GetRandomFileName() -replace '\.\w+$', '.msi') -Force -ItemType File
}
$url = "https://msedge.sf.dl.delivery.mp.microsoft.com/filestreamingservice/files/f626650a-cf6a-4f73-ab30-3889c621001f/MicrosoftEdgeEnterpriseX64.msi"

# check if we can make https requests and download the binary
try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $url -Method Head | Where-Object -FilterScript { $_.StatusCode -ne 200 }  # Suppress success output
}
catch {
    Write-Host "Unable to download $installer. Please check your internet connection."
    exit
}

Invoke-WebRequest -OutFile $tmp $url

Start-Process $tmp /q