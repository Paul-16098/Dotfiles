Write-Output "Checking for NuShell updates..."

Stop-Process -Name nu

cargo install --locked --git https://github.com/nushell/nushell.git nu -F full
cargo install --locked --git https://github.com/nushell/nushell.git nu_plugin_formats nu_plugin_polars nu_plugin_query

pause
