function Invoke-Starship-TransientFunction {
    starship prompt --profile transient_prompt 
}
Invoke-Expression (&starship init powershell)
Enable-TransientPrompt



#f45873b3-b655-43a6-b217-97c00aa0db58 PowerToys CommandNotFound module

Import-Module -Name Microsoft.WinGet.CommandNotFound
#f45873b3-b655-43a6-b217-97c00aa0db58

Set-PSReadLineOption -Colors @{ "Selection" = "`e[7m" }
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
carapace _carapace | Out-String | Invoke-Expression

atuin init powershell --disable-ctrl-r | Out-String | Invoke-Expression

###

Set-PSReadLineKeyHandler -Chord "Ctrl+d" -BriefDescription "Exits the shell" -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert(' exit')
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
