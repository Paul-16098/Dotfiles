const self = path self .

open ($self | path join "yazi.raw.toml") --raw
| str replace --all '{nu}' $"nu --config ~\\($nu.config-path | path relative-to ~) --env-config ~\\($nu.env-path | path relative-to ~)"
| from toml | save ($self | path join "yazi.toml") --force
