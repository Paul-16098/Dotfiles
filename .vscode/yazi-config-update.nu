open AppData/Roaming/yazi/config/yazi.raw.toml --raw
| str replace --all '{nu}' $"nu --config ~\\($nu.config-path | path relative-to ~) --env-config ~\\($nu.env-path | path relative-to ~)"
| from toml | save AppData/Roaming/yazi/config/yazi.toml --force
