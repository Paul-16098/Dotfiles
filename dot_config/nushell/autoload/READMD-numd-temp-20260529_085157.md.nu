# this script was generated automatically using numd
# https://github.com/nushell-prophet/numd

const init_numd_pwd_const = 'C:/Users/pl816/.local/share/chezmoi'

def ls-commands [ name: string ]: [nothing -> table] {
  help commands
  | where name starts-with $name
  | select name description
  | str replace --regex $"^($name) " "" name | sort
}

"#code-block-marker-open-1
```nu s" | print
"use ./chezmoi-completion.nu
ls-commands chezmoi-completion | to md" | nu-highlight | print

"```\n```output-numd" | print

use ./chezmoi-completion.nu
ls-commands chezmoi-completion | to md | table --width ($env.numd?.table-width? | default 120) | default '' | into string | lines | each { $'# => ($in)' | str trim --right } | str join (char nl) | str replace -r '\s*$' (char nl) | print; print ''
print ''
"```" | print
