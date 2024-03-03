$not_before = 1709201598
$expires_in = 86399
$expires_on = 1709288298

#Get Current time in unix format
$CurrentTime = ([DateTimeOffset]$(Get-Date)).ToUnixTimeSeconds()
Write-host $(Get-Date)
Write-Host $CurrentTime

# Method 1
# $not_before = (Get-Date 01.01.1970).AddSeconds($not_before)  
# $expires_in = (Get-Date).AddSeconds($expires_in)
# $expires_on = (Get-Date).AddSeconds($expires_on)
#Method 2
$not_before = [DateTimeOffset]::FromUnixTimeSeconds($not_before).DateTime
$expires_in = [DateTimeOffset]::FromUnixTimeSeconds($expires_in).DateTime
$expires_on = [DateTimeOffset]::FromUnixTimeSeconds($expires_on).DateTime

write-host $expires_on -ForegroundColor red
$expires_in = 86399
$days_left = [Math]::Ceiling($expires_in / 86400)
Write-Host "Number of days left: $days_left"

$expires_in = 86399
$minutes_left = [Math]::Ceiling($expires_in / 60)
Write-Host "Number of minutes left: $minutes_left"
