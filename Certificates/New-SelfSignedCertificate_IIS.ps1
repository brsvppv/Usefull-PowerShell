# Import the PKI module
Import-Module PKI -Verbose

# Define certificate parameters
$CertificateName = 'teamvisionbulgaria.onmicrosoft.com'
$OU = 'Organizational Unit'
$ORG = 'Organization'
$Country = 'Country Abr (US,UK etc)'
$MachineName = ([System.Net.Dns]::GetHostByName($ENV:COMPUTERNAME).HostName).ToLower()
# Define subject name
$DnsName = @($($MachineName), $(($env:COMPUTERNAME).ToLower()))
# Define certificate parameters
$certParams = @{
    Type              = 'Custom'
    Subject           = "CN=$(($MachineName).ToLower()), OU=$($OU), O=$($ORG), C=$($Country)"
    DnsName           = $DnsName
    FriendlyName      = "Certificated Used By $($CertificateName)"
    CertStoreLocation = "Cert:\LocalMachine\My"
    Provider          = "Microsoft RSA SChannel Cryptographic Provider"
    KeySpec           = 'KeyExchange'
    KeyUsage          = 'DigitalSignature', 'KeyEncipherment', 'DataEncipherment', 'CertSign' # Key Usage (within limitations)
    HashAlgorithm     = "SHA256"
    KeyAlgorithm      = "RSA"
    KeyLength         = 2048
    NotAfter          = (Get-Date).AddYears(10)
    TextExtension     = @(
        #Basic Constraints: Subject Type=CA, Path Length Constraint=0
        "2.5.29.19={text}CA=true&PathLength=0", 
        #Enhanced Key Usage: Server Authentication, Client Authentication
        "2.5.29.37={text}1.3.6.1.5.5.7.3.1,1.3.6.1.5.5.7.3.2"
    )
}

# Create the certificate
$Certificate = New-SelfSignedCertificate @certParams
$FilePath = [Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments)
# Export the certificate to a .pfx file
$password = ConvertTo-SecureString -String "YourPasswordHere" -AsPlainText -Force
Export-PfxCertificate -Cert $Certificate -FilePath "$FilePath\$($CertificateName).pfx" -Password $password

# Export the certificate to a .cer file
Export-Certificate -Cert $Certificate -FilePath "$FilePath\$($CertificateName).cer"

Write-Host "Certificate created and exported successfully:"
Write-Host "PFX file: $($CertificateName).pfx"
Write-Host "CER file: $($CertificateName).cer"