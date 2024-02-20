
# info : Name,PrimaryOwnerName,Domain,TotalPhysicalMemory,Model,Manufacturer
Get-CimInstance -ClassName Win32_ComputerSystem

# get device serialnu   
Get-WmiObject Win32_BIOS | Select-Object SerialNumber