$IsAdmin = [Security.Principal.WindowsIdentity]::GetCurrent()
If ((New-Object Security.Principal.WindowsPrincipal $IsAdmin).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) -eq $FALSE) {
    # ReLunch With Admin Rights
    # Create a new process object that starts PowerShell
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe";
    # Specify the current script path and name as a parameter
    $newProcess.Arguments = $myInvocation.MyCommand.Definition;
    # Indicate that the process should be elevated
    $newProcess.Verb = "runas";
    #$newProcess.WindowStyle = "Hidden"
    # Start the new process
    [System.Diagnostics.Process]::Start($newProcess);
    # Exit from the current, unelevated, process
    exit
}
write-host 'Here is the script to be executed as admin if you have rights'
Pause