$subject = "$($env:COMPUTERNAME).$($env:USERDOMAIN)" #(Read-Host Subhect Name)
$FriendlyName = $($env:COMPUTERNAME)
$Organization = "Team VISION - Bulgaria Ltd." #(Read-Host Organization Name)
$OrgUnit = "Team VISION - Bulgaria Ltd." #(Read-Host Organizational Unit)
$emailSettings = "office@team-vision.bg"#(Read-Host Email:)
$Location = "SF" #(Read-Host Location)
#$State = #(Read-Host State)
$Country = "BG" #(Read-Host Country/BG/EN/US/)
$alg = "SHA256" #(Read-Host SHA Algorythm)
$dnsName1 = $($env:COMPUTERNAME)
$dnsName2 = "$($env:COMPUTERNAME).$($env:USERDOMAIN)"
$years = 3 #(Read-Host Certificate Years)

$params = @{
    Subject           = "CN=$subject, O=$Organization, OU=$OrgUnit, E=$emailSettings, L=$Location, C=$Country"
    KeyUsage          = @("NonRepudiation", "KeyEncipherment", "DigitalSignature")
    FriendlyName      = $FriendlyName
    HashAlgorithm     = $alg
    KeyLength         = 2048
    KeyAlgorithm      = "RSA" 
    NotAfter          = (Get-Date).AddYears($years)
    CertStoreLocation = 'cert:\LocalMachine\My'
    DnsName           = $dnsName1, $dnsName2
    KeyExportPolicy   = 'Exportable'
    TextExtension     = ("2.5.29.19={text}CA=true")

    #SubjectAlternativeName = @("$dnsName1", "$dnsName2", "$dnsName3", "$dnsName4")
}

New-SelfSignedCertificate  @params
