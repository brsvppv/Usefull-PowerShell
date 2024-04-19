#Method 1
# Set credentials
$username = "YourUserName"
$PlainPass = "Your Password"
# Create the credentials object
$securepassword = ConvertTo-SecureString -String $PlainPass -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential ($username, $securepassword)

#$Credentials = New-Object System.Net.NetworkCredential("$sendermail", "$key"); 

#Method 2
# Passing directly secure string password
$username = "YourUserName"
$SecurePassword = (Read-Host Password -AsSecureString)

# Create the credentials object
$Credentials = New-Object System.Management.Automation.PSCredential ($username, $securepassword)

#Method 3
#using NetworkCredential
$username = "YourUserName"
$plainPass = "Your Password"
$Credentials = New-Object System.Net.NetworkCredential($username, $plainPass)