function Add-FwAllowRule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Name,
        [Parameter(Mandatory)]
        [int]$Port,
        [Parameter(Mandatory)]
        [string]$Protocol
    )
    New-NetFirewallRule -DisplayName $Name -Direction Inbound -LocalPort $Port -Protocol $Protocol -Action Allow
}

Add-FwRule -Name 'SQLServer default instance' -Port 1433 -Protocol 'TCP'