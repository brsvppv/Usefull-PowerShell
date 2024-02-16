function New-MailNotification {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][Alias('Sender')][string]$From,
        [Parameter(Mandatory)][Alias('Password')][string]$PassKey,
        [Parameter(Mandatory)][Alias('Receiver')][string]$To,
        [Parameter()][Alias('CCReceiver')][string]$CC,
        [Parameter(Mandatory)][Alias('MailSubject')][string]$Subject,
        [Parameter(Mandatory)][Alias('Header')][string]$MailHeader,
        [Parameter(Mandatory)][Alias('Content')][string]$MailBody,
        [Parameter()][string]$SMTP,
        [Parameter()][Alias('AttachedFile')]
        [ValidateScript({
                if (-not $_) { $true } # Allow null or empty value
                elseif (Test-Path $_ -PathType Leaf) { $true }
                else { throw "Attachment '$_' does not exist." }
            })][string]$Attachment,
        [Parameter()][string]$NotificationErrorLog = "$Env:LOCALAPPDATA\PowerShell Mail\ErrorLog.log",
        [Parameter()][bool]$StopLoop = $false,
        [Parameter()][int]$RetryCount = 0,
        [Parameter()][string]$TimeStamp = "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date) 
    )
    try {
        if (!$SMTP) { $SMTP = 'smtp.office365.com' }
        $msg = New-Object Net.Mail.MailMessage 
        $smtpClient = New-Object Net.Mail.SmtpClient($SMTP) 
        $smtpClient.EnableSsl = $true 
        $msg.From = $From  
        $msg.To.Add($To) 
        if ($CC) { $msg.CC.Add($CC) }
        if ($Attachment) { $msg.Attachments.Add($Attachment) }
        $msg.IsBodyHTML = $true  
        $msg.Subject = $Subject
        $msg.Body = "<h1>$MailHeader</h1><br/>$MailBody"

        $smtpClient.Credentials = New-Object System.Net.NetworkCredential($From, $PassKey)
        $smtpClient.Send($msg)

        $msg.Attachments.Dispose()
        $smtpClient.Dispose()
        $msg.Dispose()

        $StopLoop = $true
    }
    catch {
        if (!(Test-Path $NotificationErrorLog)) {
            New-Item $NotificationErrorLog -Type File -Force | Out-Null
        } 

        if ($RetryCount -le 2) {
            Start-Sleep -Seconds 1
            $RetryCount++
            Add-Content -Path $NotificationErrorLog -Value "Sending Attempt $RetryCount`r`nSending Time: $TimeStamp`r`nError: $_`r`n"
        }
        else {
            $StopLoop = $true
            throw "Failed to send email after $RetryCount attempts. Error: $_"
        }
    }
}

New-MailNotification  -SMTP "" `
    -From '' `
    -Password '' `
    -To '' `
    -Subject '' `
    -Header '' `
    -Content '' 