# Enable Remote Desktop
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0

# Allow connections through the firewall
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Restart the Remote Desktop Services to apply changes
Restart-Service -Name TermService -Force
