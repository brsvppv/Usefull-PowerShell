$subject = "Team VISION - Bulgaria Ltd" #(Read-Host Subhect Name)
$FriendlyName = 'TeamVISIONBulgaria.onmicrosoft.com'
$Organization = "Team VISION - Bulgaria Ltd." #(Read-Host Organization Name)
$OrgUnit = "Team VISION - Bulgaria Ltd." #(Read-Host Organizational Unit)
$emailSettings = "office@team-vision.bg"#(Read-Host Email:)
$Location = "SF" #(Read-Host Location)
#$State = #(Read-Host State)
$Country = "BG" #(Read-Host Country/BG/EN/US/)
$alg = "SHA256" #(Read-Host SHA Algorythm)
$dnsName1 = "DNS1" #(Read-Host Alternative Name 1)
$dnsName2 = "DNS2" #(Read-Host Alternative Name 2)
$dnsName3 = "DNS3" #(Read-Host Alternative Name 3)
$dnsName4 = "DNS4" #(Read-Host Alternative Name 4)
$years = 3 #(Read-Host Certificate Years)

$params = @{
    Subject            = "CN=$subject, O=$Organization, OU=$OrgUnit, E=$emailSettings, L=$Location, C=$Country"
    KeyUsage           = @("NonRepudiation", "KeyEncipherment", "DigitalSignature")
    FriendlyName       = $FriendlyName
    SignatureAlgorithm = $alg
    KeyLength          = 2048
    NotAfter           = (Get-Date).AddYears($years)
    StoreLocation      = 'LocalMachine'
    IsCA               = $true
    Exportable         = $true
    #SubjectAlternativeName = @("$dnsName1", "$dnsName2", "$dnsName3", "$dnsName4")
}

New-SelfSignedCertificate  @params
