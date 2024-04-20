Function Get-Anydesk() {
    param(
        $url = 'https://download.anydesk.com/AnyDesk.exe',

        $localPath = (Join-Path $env:ProgramData -ChildPath 'Anydesk'),

        $userDesktop = (New-Object -ComObject Shell.Application).NameSpace('shell:Desktop').Self.Path
    )
    if (Test-Path $localPath) { Remove-Item -LiteralPath $localPath -Force -Recurse }

    if (Test-Path $env:APPDATA\Anydesk) { Remove-Item -LiteralPath $env:APPDATA\Anydesk -Force -Recurse }
    
    if (Test-Path "$userDesktop\Anydesk.lnk") { Remove-Item -Path "$userDesktop\Anydesk.lnk" }

    New-item -Path $localPath -ItemType Directory

    Invoke-WebRequest -Uri $url -OutFile $localPath\Anydesk.exe -ErrorAction Stop 
    
    New-Item -ItemType SymbolicLink -Path  $userDesktop  -Name "Anydesk.lnk" -Value "$localPath\Anydesk.exe"
}
Get-Anydesk