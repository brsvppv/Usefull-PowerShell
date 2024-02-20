function Get-RandomPassword {
    param (
        [int]$length = 12  # Set the desired length of the password
    )

    $password = ''
    for ($i = 0; $i -lt $length; $i++) {
        $randomNumber = Get-Random -Minimum 33 -Maximum 127
        $password += [char]$randomNumber
    }

    return $password
}

# Example: Generate a random password with the default length (12 characters)
$randomPassword = Get-RandomPassword
Write-Host "Random Password: $randomPassword"
