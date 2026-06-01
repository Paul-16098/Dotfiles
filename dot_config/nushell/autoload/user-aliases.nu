# Edit this completions.
export def "config user-aliases" []: nothing -> nothing {
  const self = path self
  run-external $env.config.buffer_editor ($self)
}

alias code = code-insiders
alias cargo = cargo auditable
alias python = ^(uv python find)
alias pip = uv pip
alias cls = clear
alias "ya pack -a" = ya pkg add
alias lzd = lazydocker
alias my-http-server = my-http-server --port (port)
# nu#16260
# alias "from editorconfig" = from ini
