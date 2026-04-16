def tmp1 []: path -> string {
  path relative-to ~ | '~\' + $in | str replace --all '\' '\\'
}

def main [] {
  open AppData/Roaming/yazi/config/yazi.raw.toml --raw
  | str replace --all '{nu}' $"nu --config ($nu.config-path | tmp1) --env-config ($nu.env-path | tmp1)"
  #   | str replace --all '{nu}' 'nu'
  | tee { print $in }
  #   | from toml
  | save AppData/Roaming/yazi/config/yazi.toml --force
}
