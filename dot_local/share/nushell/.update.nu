const self = path self

export def main [] {
  use ~\.config\nushell\nupm\modules\numd
  $env.config.table.missing_value_symbol = "[X]"
  numd run ($self | path dirname | path join ./README.md) --use-host-config --ignore-git-check
}
