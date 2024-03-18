# Check if winget is already installed
$wingetVersion = (Invoke-Expression "winget -v" -ErrorAction SilentlyContinue)

# Retrieve latest release information from GitHub API
$latestRelease = Invoke-RestMethod -Uri 'https://api.github.com/repos/microsoft/winget-cli/releases/latest'

$latest = $latestRelease.tag_name.Remove(0, 1)
$wingetVersion = $wingetVersion.Remove(0, 1)

$latestVersion = [Version]$latest
$instVersion = [Version]"$wingetVersion"

if ($latestVersion -eq $instVersion) {
    Write-Host "Versions are equal"
} 
elseif ($latestVersion -lt $instVersion) {
    Write-Host "$latestVersion is less than $instVersion"
} 
else {
    Write-Host "$latestVersion is greater than $instVersion"
}