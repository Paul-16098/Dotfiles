const self = path self

export def main [] {
  use ~\.config\nushell\nupm\modules\numd
  $env.config.table.missing_value_symbol = "[X]"
  (glob **/*.md --no-dir | par-each {|e| numd run $e --use-host-config --ignore-git-check --eval (view source ls-commands) | reject filename | upsert path ($e | path relative-to (pwd)) | move path --first })
}

export def ls-commands [name: string]: nothing -> table {
  help commands
  | where name starts-with $name
  | select name description
  | str replace --regex $"^($name) " "" name | sort
}
