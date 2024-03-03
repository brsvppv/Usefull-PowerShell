$not_before = 1709201598
$expires_in = 86399
$expires_on = 1709288298


$not_before = (Get-Date 01.01.1970).AddSeconds($tokenResponse.not_before)  
$expires_in = (Get-Date).AddSeconds($tokenResponse.expires_in)
$expires_on = (Get-Date).AddSeconds($tokenResponse.expires_on)

$not_before = [DateTimeOffset]::FromUnixTimeSeconds($tokenResponse.not_before).DateTime
$expires_in = [DateTimeOffset]::FromUnixTimeSeconds($tokenResponse.expires_in).DateTime
$expires_on = [DateTimeOffset]::FromUnixTimeSeconds($tokenResponse.expires_on).DateTime

$expires_in = 86399
$days_left = [Math]::Ceiling($expires_in / 86400)
Write-Host "Number of days left: $days_left"

$expires_in = 86399
$minutes_left = [Math]::Ceiling($expires_in / 60)
Write-Host "Number of minutes left: $minutes_left"
