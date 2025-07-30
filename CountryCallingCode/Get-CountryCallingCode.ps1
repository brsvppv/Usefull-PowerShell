function Get-CallingCodes {
    param (
        [string]$CountryCode
    )

    # Fetch all countries from the API
    $countries = Invoke-RestMethod -Uri "https://restcountries.com/v3.1/all?fields=cca2,cca3,idd"

    # Filter the country by its country code (cca2 or cca3)
    $country = $countries | Where-Object { $_.cca2 -eq $CountryCode -or $_.cca3 -eq $CountryCode }

    # Check if the country was found
    if ($country) {
        # Extract the calling codes (handles multiple suffixes)
        $callingCodes = $country.idd.root + ($country.idd.suffixes -join ", ")

        return $callingCodes
    }
    else {
        return "Country code '$CountryCode' not found."
    }
}

# Example usage
Get-CallingCodes -CountryCode "BG"  # United Kingdom

