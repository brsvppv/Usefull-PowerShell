function Invoke-ChocolateyCheck {
    try {
        $chocoVersion = (Invoke-Expression "choco -v" -ErrorAction Stop)
        Write-Host "Chocolatey Version $chocoVersion is already installed." -ForegroundColor Green
    }
    catch {
        if ($_.Exception.Message -like '*not recognized*') {
            Write-Host "Chocolatey is not installed. Installing now..." -ForegroundColor Cyan
            # Your installation logic goes here
            Set-ExecutionPolicy Bypass -Scope Process -Force; 
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
            Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        }
        else {
            Write-Host "Error occurred: $($_.Exception.Message)" -ForegroundColor Red
            [System.Windows.MessageBox]::Show("Error Occurred: $($_.Exception.Message)", 'Error', 'OK', 'Error')
        }
    }
}

# Call the function to check and install Chocolatey
Check-Chocolatey
