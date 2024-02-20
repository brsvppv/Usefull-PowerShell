# Load .NET assembly
Add-Type -AssemblyName System.Web

# Generate a random password of length 10
$password = [System.Web.Security.Membership]::GeneratePassword(15, 2)

# Output the password
Write-Output "Generated Password: $password"