#winrm enumerate winrm/config/Listener
#Get-ChildItem -Path WSMan:\localhost\Listener | Where-Object { $_.Keys -contains "Transport=HTTPS" } | Remove-Item -Recurse -Force
#$userDesktop = (New-Object -ComObject Shell.Application).NameSpace('shell:Desktop').Self.Path
#$exportPath = (Read-Host Export Certificate Keys Path)

$userDirectory = '\\tvbg\root\nf\Shared\!DO_NOT_DELETE!\ADM\Certificates\'

$MachineName = "$($env:COMPUTERNAME).$($env:USERDOMAIN)"
$Network = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -eq "Ethernet" }

$exportPath = Join-Path -Path $userDirectory -ChildPath 'WinRMs'
#$MachineName = [System.Net.Dns]::GetHostByName($ENV:COMPUTERNAME).HostName

if (!(Test-Path $exportPath)) { New-Item -Path $exportPath -ItemType Directory }

# $cert = New-SelfSignedCertificate -Type Custom `
#     -Subject "CN=$env:USERNAME" `
#     -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2, 1.3.6.1.5.5.7.3.1", "2.5.29.17={text}upn=$env:USERNAME@$env:USERDOMAIN") `
#     -KeyUsage DigitalSignature, KeyEncipherment `
#     -KeyAlgorithm RSA `
#     -KeyLength 2048 `
#     -NotAfter (Get-Date).AddYears(10)

$certInfo = New-SelfSignedCertificate -Type Custom -Subject "CN=$MachineName" `
    -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2, 1.3.6.1.5.5.7.3.1",
    "2.5.29.17={text}dns=$MachineName,&dns=$env:COMPUTERNAME&IPAddress=$($Network.IPAddress)&upn=$env:USERNAME@tvbg") `
    -FriendlyName 'Ansible WinRMs HTTPs' `
    -KeySpec 'KeyExchange' `
    -Provider "Microsoft RSA SChannel Cryptographic Provider" `
    -KeyUsage "NonRepudiation", "KeyEncipherment", "DigitalSignature" `
    -KeyAlgorithm "RSA" `
    -KeyLength 2048 `
    -HashAlgorithm "SHA256" `
    -CertStoreLocation "cert:\LocalMachine\My" `
    -NotAfter (Get-Date).AddYears(10)

$cert = Get-Item "$($certInfo.PSPath)"

#Public key to base64
$PublicKeyBase64 = [System.Convert]::ToBase64String($cert.RawData, [System.Base64FormattingOptions]::InsertLineBreaks)

#Private key to Base64
$RSACng = [System.Security.Cryptography.X509Certificates.RSACertificateExtensions]::GetRSAPrivateKey($cert)
$KeyBytes = $RSACng.Key.Export([System.Security.Cryptography.CngKeyBlobFormat]::Pkcs8PrivateBlob)
$PrivateKeyBase64 = [System.Convert]::ToBase64String($KeyBytes, [System.Base64FormattingOptions]::InsertLineBreaks)

$Pem = @"
-----BEGIN PRIVATE KEY-----
$PrivateKeyBase64
-----END PRIVATE KEY-----

-----BEGIN CERTIFICATE-----
$PublicKeyBase64
-----END CERTIFICATE-----
"@

#$Pem | Out-File -FilePath $exportPath\$($cert.Subject.Replace('CN=','')).pem -Encoding Ascii
[System.IO.File]::WriteAllLines("$exportPath\$($cert.Subject.Replace('CN=','')).pem", $Pem)
[System.IO.File]::WriteAllBytes("$exportPath\$($cert.Subject.Replace('CN=','')).pfx", $cert.Export("Pfx"))
Export-Certificate -Cert $cert -FilePath "$exportPath\$($cert.Subject.Replace('CN=','')).cer"  

Get-ChildItem -Path cert:\LocalMachine\Root\ -Recurse | Where-Object { $_.Thumbprint -eq $cert.Thumbprint } | Select-Object *

$selector_set = @{
    Address   = "*"
    Transport = "HTTPS"
}
$value_set = @{
    CertificateThumbprint = $cert.Thumbprint
}

New-WSManInstance -ResourceURI "winrm/config/Listener" -SelectorSet $selector_set -ValueSet $value_set

$FirewallParam = @{
    DisplayName = 'Windows Remote Management (HTTPS-In)'
    Direction   = 'Inbound'
    LocalPort   = 5986
    Protocol    = 'TCP'
    Action      = 'Allow'
    Program     = 'Any'
}
New-NetFirewallRule @FirewallParam
