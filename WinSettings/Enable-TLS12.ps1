Function Enable-TLS12 {
    param(
        [ValidateSet("Server", "Client")]
        [String]$Component = "Server"
    )
    try {

        $protocols_path = 'HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols'
        New-Item -Path "$protocols_path\TLS 1.2\$Component" -Force
        New-ItemProperty -Path "$protocols_path\TLS 1.2\$Component" -Name Enabled -Value 1 -Type DWORD -Force
        New-ItemProperty -Path "$protocols_path\TLS 1.2\$Component" -Name DisabledByDefault -Value 0 -Type DWORD -Force
    }
    catch {
        Write-Output $_.Exception
    }
}

Enable-TLS12 -Component Server

# Not required but highly recommended to enable the Client side TLS 1.2 components
#Enable-TLS12 -Component Client

Restart-Computer