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
    -CertStoreLocation "Cert:\CurrentUser\My" `
    -NotAfter (Get-Date).AddYears(10)
    
#-TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2, 1.3.6.1.5.5.7.3.1", "2.5.29.17={text}upn=$username@localhost") `

#Client Authentication + Server Authentication
#-TextExtension "2.5.29.37={text}1.3.6.1.5.5.7.3.1, 1.3.6.1.5.5.7.3.2" `

#-TextExtension These key usages have the following object identifiers:

#Client Authentication: 1.3.6.1.5.5.7.3.2
#Server Authentication: 1.3.6.1.5.5.7.3.1
#Secure Email: 1.3.6.1.5.5.7.3.4
#Code Signing: 1.3.6.1.5.5.7.3.3
#Timestamp Signing: 1.3.6.1.5.5.7.3.8

# Enhanced Key Usage Object Identifiers extension example: 2.5.29.37={text}{oid},{oid}...
# Name Constraints extension example: 2.5.29.30={text}subtree=include&{token}={value}&{token}={value}&subtree=exclude&{token}={value}...