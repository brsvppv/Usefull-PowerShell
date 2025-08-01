function Get-CallingCode {
    param (
        [Parameter(Mandatory)]
        [string]$CountryCode
    )

    try {
        # Fetch all countries from the API
        $countries = Invoke-RestMethod -Uri "https://restcountries.com/v3.1/all?fields=cca2,cca3,idd"

        # Filter the country by its country code (cca2 or cca3)
        $country = $countries | Where-Object {
            $_.cca2 -eq $CountryCode -or $_.cca3 -eq $CountryCode
        }

        # Check if the country was found
        if ($country) {
            # Extract the calling codes
            $prefix = $country.idd.root
            $suffixes = $country.idd.suffixes

            # Combine prefix with each suffix and return as an array
            $callingCodes = $suffixes | ForEach-Object { "$prefix$_" }

            return $callingCodes
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
$countryCode = "BG"
$callingCodes = Get-CallingCode -CountryCode $countryCode

if ($callingCodes) {
    Write-Host "The calling codes for country code '$countryCode' are:"
    $callingCodes
    # for ($i = 0; $i -lt $callingCodes.Count; $i++) {
    #     Write-Host "$($callingCodes[$i])"
    # }
}
else {
    Write-Host "No calling code found for country code '$countryCode'."
}
