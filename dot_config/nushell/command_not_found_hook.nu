export-env {
  $env.config.hooks.command_not_found = {|cmd|
    let cmds = (
      scope commands
      | where name has $cmd and type == custom
      | get name
    )
    if $cmds != [] {
      let cmds_csv = $cmds | each {|c| '`' + $c + '`' } | str join ', '
      return ('Did you mean ' + $cmds_csv + '?')
    }
    auto-use --strict $cmd
  }
}
def auto-use [--strict (-s) mod: string]: nothing -> nothing {
  let paths = find-modules --strict=$strict $mod
  let selection = match ($paths | length) {
    0 => null
    1 => $paths.0
    _ => { $paths | input list --fuzzy }
  }
  if ($selection | is-empty) {
    return
  }
  commandline edit --replace ('use ' + $selection)
}

def find-modules [--strict (-s) name: string]: nothing -> list<path> {
  $NU_LIB_DIRS ++ $env.NU_LIB_DIRS | uniq
  | each --flatten {|d| if ($d | path exists) { cd $d; glob --no-dir --no-symlink **/*.nu | path relative-to $d } }
  | path parse
  | if $strict {
    where $it.stem == $name or (($it.parent | path basename) == $name and $it.stem == mod)
  } else {
    where $it.stem has $name or (($it.parent | path basename) has $name and $it.stem == mod)
  }
  | par-each --keep-order {
    path join
    | if ($in ends-with 'mod.nu') {
      str replace --regex 'mod\.nu$' ''
    } else {}
  }
}
