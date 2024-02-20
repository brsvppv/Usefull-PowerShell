Write-Host "Select Disk Partition to Repair" -foreground "Yellow"

Get-Volume | Format-Table -AutoSize -Property 'DriveLetter', 'FileSystemType', 'HealthStatus'

''
$diskVolume = (Read-Host Volume Letter)
''
Write-Host " 1 - Scans the Volume '$diskVolume' and reports errors only." -ForegroundColor Green
Write-Host " 3 - Uses the spot verifier functionality to quickly fix drive '$diskVolume'." -ForegroundColor Green
Write-Host " 2 - Takes the drive '$diskVolume' offline, and fixes all issues." -ForegroundColor Red
''
$repairOption = (Read-Host Select Repair Method '(1/2/3)')

if ($repairOption -eq 1) {
    Repair-Volume -DriveLetter $diskVolume -Scan
}
if ($repairOption -eq 2) {
    Repair-Volume -DriveLetter $diskVolume -SpotFix
   
}
if ($repairOption -eq 3) { 
    Repair-Volume -DriveLetter $diskVolume -OfflineScanAndFix
}
else
{ Exit; }

