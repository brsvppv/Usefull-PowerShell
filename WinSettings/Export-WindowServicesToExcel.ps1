Function Export-ServicesToExcel {

    $Services = (Get-Service | Select-Object Status, Name, DisplayName)
    $Excel = New-Object -ComObject Excel.Application
    $Excel.Visible = $true
    $Workbook = $excel.Workbooks.Add()
    $Sheets = $workbook.Worksheets
    $Services
    $CurrentWorkSheet = $Sheets.Add()
    $lineNo = 1
    # Create Headers
    $currentWorkSheet.Cells.Item($lineNo, 1) = "Name"
    $currentWorkSheet.Cells.Item($lineNo, 2) = "DisplayName"
    $currentWorkSheet.Cells.Item($lineNo, 3) = "Status"
    $currentWorkSheet.Cells.Item($lineNo, 4) = "Status Int[32]"

    $format = $currentWorkSheet.UsedRange
    $format.Font.Bold = "True"
    #add each service
    foreach ($Service in $Services) {
    
        $lineNo = $lineNo + 1
        $currentWorkSheet.Cells.Item($lineNo, 1) = $Service.DisplayName
        $currentWorkSheet.Cells.Item($lineNo, 2) = $Service.Name
        $currentWorkSheet.Cells.Item($lineNo, 3) = $Service.Status.ToString()
        $currentWorkSheet.Cells.Item($lineNo, 4) = $Service.Status
    
    }
    $Excel.Quit()
}Export-ServicesToExcel