Write-Output "Checking for NuShell updates..."
$commandline_is_null = (($null -ne $env:NU_COMMANDLINE) -or ($env:NU_COMMANDLINE -ne ""))

Get-Process -Name nu | Stop-Process
cargo install --locked --git https://github.com/nushell/nushell.git nu -F full
if ($commandline_is_null) {
	Write-Output "NuShell updated, but no commandline to run."
}
else {
	Write-Output "NuShell updated, running ``$env:NU_COMMANDLINE``."
	Start-Process nu -ArgumentList @('--commands=' + $env:NU_COMMANDLINE)
}
pause
