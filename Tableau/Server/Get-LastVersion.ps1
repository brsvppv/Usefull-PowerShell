Function Get-TSLastVersion() {
    #Define Web Request LInk
    $WebResponse = Invoke-WebRequest 'https://www.tableau.com/support/releases/server'
    #Get Link in the HTML for realsed version
    $ReleasedVersions = $WebResponse.Links 
    #Define Array Container for realsed version for filter
    $VersionList = New-Object System.Collections.Generic.List[System.Object]
    #Get each Released Versiom in List 
    ForEach ($version in $ReleasedVersions | Where-Object { $_.InnerText -match "Released" }  ) {
        $VersionInfo = $version.outerText.ToString().Split(' ')
        $VersionList.Add($VersionInfo[1])
    }
    #Check the version for Lenght
    if ($VersionList[0].Length -lt 8 ) {
        $VersionList[0] = $VersionList[0] + ".0"
    }
    #Build Download URL
    $RootURL = 'https://downloads.tableau.com/esdalt'
    $VerURL = $VersionList[0]
    $ObjectLink = $VersionList[0].Replace("." , "-")
    $ObjectFile = "TableauServer-64bit-" + "$ObjectLink" + ".exe"
    $FileURL = ($RootURL, $VerURL, $ObjectFile ) -Join ("/")

    #Get user download location 
    $UserDownloads = (New-Object -ComObject Shell.Application).NameSpace('shell:Downloads').Self.Path
    write-host "Version Directory" $VersionList[0] -ForegroundColor Green
    write-host "Version File: $ObjectFile" -ForegroundColor Cyan
    Write-Warning "URL: $FileURL"

    Try {
        Start-BitsTransfer -Source $FileURL -Destination $UserDownloads -TransferType Download -Priority Foreground 
    }
    Catch {
        Write-Output $_
    }

}
Get-TSLastVersion