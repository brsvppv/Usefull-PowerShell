function Invoke-Speech {
    [CmdletBinding()]
    param (
        [Parameter(Position = 0)]
        [string]$Computer
    )

    if (-not $Computer) {
        # Local speech
        $Text = Read-Host 'Enter text to speak'

        Add-Type -AssemblyName System.Speech
        $synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
        $synth.Speak($Text)
    }
    else {
        # Remote speech via PowerShell Remoting
        $Credential = Get-Credential

        try {
            $Session = New-PSSession -ComputerName $Computer -Credential $Credential

            Invoke-Command -Session $Session -ScriptBlock {
                $Text = Read-Host 'Enter text to speak'
                Add-Type -AssemblyName System.Speech
                $synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
                $synth.Speak($Text)
            }

            Remove-PSSession -Session $Session
        }
        catch {
            Write-Error "Failed to connect to $Computer $_"
        }
    }
}

Invoke-Speech