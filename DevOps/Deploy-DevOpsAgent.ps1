function Install-DevOpsAgent {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$AgentPool,

        [Parameter(Mandatory = $true)]
        [string]$Token,

        [Parameter(Mandatory = $true)]
        [string]$URL,

        [Parameter(Mandatory = $true)]
        [string]$ServiceAccount,

        [Parameter(Mandatory = $false)]
        [string]$DownloadLink = 'https://vstsagentpackage.azureedge.net/agent/2.153.1/vsts-agent-win-x64-2.153.1.zip',

        [Parameter(Mandatory = $false)]
        [string]$AgentWorkDir = '_work'
    )

    # Check for Administrative Privileges
    $IsAdmin = [Security.Principal.WindowsIdentity]::GetCurrent()
    If ((New-Object Security.Principal.WindowsPrincipal $IsAdmin).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator) -eq $FALSE) {
        Write-Host "🔒 Relaunching script with elevated privileges..."
        $newProcess = new-object System.Diagnostics.ProcessStartInfo "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
        $newProcess.Arguments = $myInvocation.MyCommand.Definition
        $newProcess.Verb = "runas"
        # $newProcess.WindowStyle = "Hidden"  # Uncomment to run the process hidden
        [System.Diagnostics.Process]::Start($newProcess)
        exit
    }

    # Check PowerShell Version
    If ($PSVersionTable.PSVersion -lt (New-Object System.Version("3.0"))) { 
        throw "The minimum version of Windows PowerShell that is required by the script (3.0) does not match the currently running version of Windows PowerShell."
    }

    # Download DevOps Agent
    $filePath = "$HOME\Downloads\vsts-agent-win-x64-2.153.1.zip"

    Write-Host "📥 Downloading DevOps Agent..."
    try {
        Invoke-WebRequest -Uri $DownloadLink -OutFile $filePath -ErrorAction Stop
    }
    catch {
        Write-Host "❗ Failed to download DevOps Agent: $($_.Exception.Message)"
        exit
    }

    # Extract DevOps Agent
    $path = "$PSScriptRoot\agent"
    if (!(Test-Path $path)) { New-Item -Path $path -ItemType Directory }

    Write-Host "📦 Extracting DevOps Agent..."
    try {
        Expand-Archive -Path $filePath -DestinationPath $path -ErrorAction Stop
    }
    catch {
        Write-Host "❗ Failed to extract DevOps Agent: $($_.Exception.Message)"
        exit
    }

    # Configure DevOps Agent
    Write-Host "🔧 Configuring DevOps Agent..."
    Set-Location $path
    try {
        cmd.exe /c config --gituseschannel --auth 'PAT' --token $Token --pool $AgentPool --runAsService --windowsLogonAccount $ServiceAccount --agent $env:COMPUTERNAME --work $AgentWorkDir --url $URL
    }
    catch {
        Write-Host "❗ Failed to configure DevOps Agent: $($_.Exception.Message)"
        exit
    }

    # Start DevOps Agent Service
    $ServiceDisplayName = "Azure Pipelines Agent (devops.$($AgentPool).$($env:COMPUTERNAME))"
    Write-Host "🚀 Starting DevOps Agent Service: $ServiceDisplayName"
    try {
        Start-Service -DisplayName $ServiceDisplayName -ErrorAction Stop
        Write-Host "✅ DevOps Agent Service started successfully."
    }
    catch {
        Write-Host "❗ Failed to start DevOps Agent Service: $($_.Exception.Message)"
    }
}


Install-DevOpsAgent -AgentPool "YouAgentPool" -Token "YourPAT" -URL "https://yourdevops/collection" -ServiceAccount "ADD SERVICE ACCOUNT"

#Custom Working Directory
#Install-DevOpsAgent -AgentPool "Default" -Token "YourPAT" -URL "https://devops.tvbg/PowerShell/" -ServiceAccount "NT AUTHORITY\NETWORK SERVICE" -AgentWorkDir "C:\AgentWork"
#Install-DevOpsAgent -AgentPool "Default" -Token "YourPAT" -URL "https://devops.tvbg/PowerShell/" -ServiceAccount "NT AUTHORITY\NETWORK SERVICE" -DownloadLink "https://example.com/path/to/agent.zip"
#Install-DevOpsAgent -AgentPool "Default" -Token "YourPAT" -URL "https://devops.tvbg/PowerShell/" -ServiceAccount "NT AUTHORITY\NETWORK SERVICE" -DownloadLink "https://example.com/path/to/agent.zip"