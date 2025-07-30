$exportPath = Join-Path -Path $env:USERPROFILE -ChildPath 'Exported-Certificate'
$MachineName = "$($env:COMPUTERNAME).$($env:USERDOMAIN)"
$Network = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -eq "Ethernet" }
if (!(Test-Path $exportPath)) { New-Item -Path $exportPath -ItemType Directory }

$certInfo = New-SelfSignedCertificate -Type Custom -Subject "CN=$MachineName" `
    -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2, 1.3.6.1.5.5.7.3.1",
    "2.5.29.17={text}dns=$MachineName,&dns=$env:COMPUTERNAME&IPAddress=$($Network.IPAddress)&upn=$env:USERNAME@tvbg") `
    -FriendlyName 'Certificate FriendlyName' `
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

Start-Process $exportPath