$RemoteMachine = "BC365"
$FilePath = "C:\Path\To\File.txt"
# Script block to execute on the remote machine
$scriptBlock = {
    param ($filePath)
    # Check if the file exists and return the result
    Test-Path $filePath
}
#Invoke the command on the remote computer
$fileExists = Invoke-Command -ComputerName $RemoteMachine -ScriptBlock $scriptBlock -ArgumentList $filePath
if ($fileExists) {
    write-host $fileExists
    Write-Host "The file exists on the remote computer."
}
else {
    write-host $fileExists
    Write-Host "The file does not exist on the remote computer."
}