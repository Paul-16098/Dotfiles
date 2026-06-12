const self = path self

# Edit this config.
export def "config user-hooks" []: nothing -> nothing {
  run-external $env.config.buffer_editor ($self)
}

# export alias l = ls
export-env {
  $env.config = (
    $env.config | upsert hooks.env_change.PWD {|config|
      let o = ($config | get --optional hooks.env_change.PWD)
      let val = [
        # toolkit
        # load
        {
          condition: {|old new|
            let file_exists = "./toolkit.nu" | path exists
            let file_active = (overlay list | where name == "toolkit" | get --optional 0?.active | default false)

            ($file_exists and not $file_active)
          }
          code: {|old new|
            const CODE = "overlay use toolkit.nu"
            print $"(ansi green)toolkit.nu(ansi reset) is exists in this directory, but not loaded.\nrun next line to activate it:"
            print ($CODE | nu-highlight)
            commandline edit $CODE
          }
        }
        # hide
        {
          condition: {|old new|
            let file_exists = "./toolkit.nu" | path exists
            let file_active = (overlay list | where name == "toolkit" | get --optional 0?.active | default false)

            (not $file_exists and $file_active)
          }
          code: {|old new|
            const CODE = "overlay hide toolkit"
            print $"(ansi green)toolkit.nu(ansi reset) is not exists in this directory, but toolkit overlay is loaded.\nrun next line to deactivate it:"
            print ($CODE | nu-highlight)
            commandline edit $CODE
          }
        }
        # venv
        # load
        {
          condition: {|old new|
            let file_exists = "./.venv/Scripts/activate.nu" | path exists
            let file_active = (overlay list | where name == "activate" | get --optional 0?.active | default false)

            ($file_exists and not $file_active)
          }
          code: {|old new|
            const CODE = "overlay use ./.venv/Scripts/activate.nu"
            print $"venv is exists in this directory, but not activated.\nrun next line to activate it:"
            print ($CODE | nu-highlight)
            commandline edit $CODE
          }
        }
        # hide
        {
          condition: {|old new|
            let file_exists = "./.venv/Scripts/activate.nu" | path exists
            let file_active = (overlay list | where name == "activate" | get --optional 0?.active | default false)

            (not $file_exists and $file_active)
          }
          code: {|old new|
            const CODE = "overlay hide activate"
            print $"venv is not exists in this directory, but activated.\nrun next line to deactivate it:"
            print ($CODE | nu-highlight)
            commandline edit $CODE
          }
        }
        # direnv
        {
          condition: {|old new| (which direnv | is-not-empty) and (('./.envrc' | path exists) or ('./.env' | path exists)) }
          code: {||
            use std/util null_device

            direnv export json e> $null_device | from json | default {} | let load_env
            if ($load_env | is-not-empty) {
              print 'direnv: export' --no-newline --stderr
              $load_env
              | transpose k v
              | each {
                if not (($in | describe) == 'record<k: string, v: nothing>') {
                  if ($in.k not-in [DIRENV_DIR DIRENV_WATCHES DIRENV_FILE DIRENV_DIFF]) {
                    print $" +(ansi green)($in.k)(ansi reset)" --no-newline --stderr
                  }
                  $in
                }
                #  else {
                #   print $" -(ansi red)($in.k)(ansi reset)" --no-newline --stderr
                #   # $in
                # }
              } | transpose --as-record --header-row
              | load-env
            }
          }
        }
      ]

      if $o == null {
        $val
      } else {
        $o ++ $val
      }
    }
  )
}
