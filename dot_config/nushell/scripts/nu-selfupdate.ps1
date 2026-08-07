Write-Output "Checking for NuShell updates..."

Get-Process -Name nu | Stop-Process

cargo install --locked --git https://github.com/nushell/nushell.git nu nu_plugin_formats nu_plugin_polars nu_plugin_query -F full
