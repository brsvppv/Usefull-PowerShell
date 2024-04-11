# Set credentials
$username = "YourUserName"
$PlainPass = "Your Password"

# Create the credentials object
$securepassword = ConvertTo-SecureString -String $PlainPass -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential ($username, $securepassword)
$Credentials
#$Credentials = New-Object System.Net.NetworkCredential("$sendermail", "$key"); 