$CertificateName = "$($env:COMPUTERNAME).$($env:USERDOMAIN)" #(Read-Host Subhect Name)
$FriendlyName = $($env:COMPUTERNAME)
$Organization = (Read-Host Organization Name)
$OrgUnit = (Read-Host Organizational Unit)
$emailSettings = (Read-Host Email:)
$Location = (Read-Host Location (ex. Sofia, Berlin, London,  New York))
#$State = #(Read-Host State)
$Country = (Read-Host Country/BG/EN/US/)
$alg = "SHA256" #(Read-Host SHA Algorythm)
$dnsName1 = $($env:COMPUTERNAME)
$dnsName2 = "$($env:COMPUTERNAME).$($env:USERDOMAIN)"
[int]$years = (Read-Host Certificate Years)

$params = @{
    Subject           = "CN=$CertificateName, O=$Organization, OU=$OrgUnit, E=$emailSettings, L=$Location, C=$Country"
    KeyUsage          = @("NonRepudiation", "KeyEncipherment", "DigitalSignature")
    FriendlyName      = $FriendlyName
    HashAlgorithm     = $alg
    KeyLength         = 2048
    KeyAlgorithm      = "RSA" 
    NotAfter          = (Get-Date).AddYears($years)
    CertStoreLocation = 'cert:\LocalMachine\My'
    DnsName           = $dnsName1, $dnsName2
    KeyExportPolicy   = 'Exportable'
    TextExtension     = ("2.5.29.19={text}CA=true") # Use CA=false for end-entity/server certs
    #SubjectAlternativeName = @("$dnsName1", "$dnsName2", "$dnsName3", "$dnsName4")
}

New-SelfSignedCertificate  @params
