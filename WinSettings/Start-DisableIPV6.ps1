Get-NetAdapter -Name *
$adapters = Get-NetAdapterBinding -ComponentID ms_tcpip6
foreach($adapter in $adapters){
Disable-NetAdapterBinding -InterfaceAlias $adapter.InterfaceAlias -ComponentID ms_tcpip6}