function Get-CallingCode {
    param (
        [Parameter(Mandatory)]
        [string]$CountryCode
    )

    try {
        # Fetch all countries from the API
        $countries = Invoke-RestMethod -Uri "https://restcountries.com/v3.1/all"

        # Filter the country by its country code (cca2 or cca3)
        $country = $countries | Where-Object {
            $_.cca2 -eq $CountryCode -or $_.cca3 -eq $CountryCode
        }

        # Check if the country was found
        if ($country) {
            # Extract the calling code
            $prefix = $country.idd.root
            $suffixes = $country.idd.suffixes
            $callingCodes = $suffixes | ForEach-Object { $prefix + $_ }

            # Join the calling codes with commas
            $callingCode = $callingCodes -join ", "

            # Return the calling code
            return $callingCode
        }
        else {
            throw "Country with code '$CountryCode' not found."
        }
    }
    catch {
        Write-Error "An error occurred: $_"
        return $null
    }
}

# Example usage:
$countryCode = "USA"
$callingCode = Get-CallingCode -CountryCode $countryCode

if ($callingCode) {
    Write-Host "The calling code for country code '$countryCode' is $callingCode."
}
else {
    Write-Host "No calling code found for country code '$countryCode'."
}