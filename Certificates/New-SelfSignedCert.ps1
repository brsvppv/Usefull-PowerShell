Import-Module PKI -Verbose

$MachineName = [System.Net.Dns]::GetHostByName($ENV:COMPUTERNAME).HostName

New-SelfSignedCertificate -Type Custom -Subject "CN=$MachineName" `
    -DnsName $MachineName, $env:COMPUTERNAME `
    -FriendlyName $env:COMPUTERNAME `
    -KeySpec 'KeyExchange' `
    -Provider "Microsoft RSA SChannel Cryptographic Provider" `
    -KeyUsage "NonRepudiation", "KeyEncipherment", "DigitalSignature" `
    -KeyAlgorithm "RSA" `
    -KeyLength 2048 `
    -HashAlgorithm "SHA256" `
    -CertStoreLocation "cert:\LocalMachine\My" `
    -NotAfter (Get-Date).AddYears(10)

#Client Authentication + Server Authentication
#-TextExtension "2.5.29.37={text}1.3.6.1.5.5.7.3.1, 1.3.6.1.5.5.7.3.2" `

#-TextExtension These key usages have the following object identifiers:

#Client Authentication: 1.3.6.1.5.5.7.3.2
#Server Authentication: 1.3.6.1.5.5.7.3.1
#Secure Email: 1.3.6.1.5.5.7.3.4
#Code Signing: 1.3.6.1.5.5.7.3.3
#Timestamp Signing: 1.3.6.1.5.5.7.3.8