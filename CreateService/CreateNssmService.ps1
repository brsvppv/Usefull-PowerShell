#navigate to nssm directory 
nssm install ServiceName "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" "-NoProfile -ExecutionPolicy Bypass -File C:\path\script.ps1"
