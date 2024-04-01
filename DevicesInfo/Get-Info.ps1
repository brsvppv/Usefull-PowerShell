
# info : Name,PrimaryOwnerName,Domain,TotalPhysicalMemory,Model,Manufacturer
Get-CimInstance -ClassName Win32_ComputerSystem

# get device serialnu   
Get-WmiObject Win32_BIOS | Select-Object SerialNumber


#
Get-WmiObject Win32_Processor | Select-Object NumberOfCores, NumberOfLogicalProcessors, LoadPercentage | Format-List

# CPU load.
Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average | Select-Object Average


#WMIC CPU Get DeviceID,NumberOfCores,NumberOfLogicalProcessors,SocketDesignation
