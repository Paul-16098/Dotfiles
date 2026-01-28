const self = path self

# Edit this completions.
export def "config user-aliases" []: nothing -> nothing {
  run-external $env.config.buffer_editor ($self)
}

export alias chad = chezmoi add
export alias chap = chezmoi apply
export alias chd = chezmoi diff
export alias chda = chezmoi data
export alias chs = chezmoi status
export alias ched = chezmoi edit