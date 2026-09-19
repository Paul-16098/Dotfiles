Write-Output "Checking for NuShell updates..."

Stop-Process -Name nu

cargo install --locked --git https://github.com/nushell/nushell.git nu -F full

pause
