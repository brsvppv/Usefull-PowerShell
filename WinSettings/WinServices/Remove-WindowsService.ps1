Function Remove-Service {
    Write-Host "Display" -nonewline; Write-Host " Running"  -foreground "Green"-nonewline; Write-Host " or" -nonewline; Write-Host " Stopped " -foreground "red" -nonewline; Write-Host "services"

    $serviceStatus = (Read-Host Service Status)

    Get-Service | Select-Object Status, Name, DisplayName | Where-Object { $_.Status -eq $serviceStatus } | Format-Table -Autosize

    Write-Host "Input the name of the service you want to delete"  -foreground "Green" 

    $serviceName = Read-Host ("Service To Delete" ) | 

    Clear-Host

    sc.exe delete $serviceName 
}
Remove-Service