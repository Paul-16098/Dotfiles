# Edit this completions.
export def "config user-aliases" []: nothing -> nothing {
  const self = path self
  run-external $env.config.buffer_editor ($self)
}

alias code = code-insiders
alias ls = ls --all --threads
alias ll = ls --long
alias cargo = cargo auditable
alias python = ^(uv python find)
alias py = python
alias pip = uv pip
alias cls = clear
alias "decode url" = url decode
alias "encode url" = url encode
alias "ya pack -a" = ya pkg add
alias lzd = lazydocker
alias .j = just
alias my-http-server = my-http-server --port (port)
# nu#16260
# alias "from editorconfig" = from ini
