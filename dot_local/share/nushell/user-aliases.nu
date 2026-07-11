# Edit this completions.
export def "config user-aliases" []: nothing -> nothing {
  const self = path self
  run-external $env.config.buffer_editor ($self)
}

export alias python = ^(uv python find)
export alias pip = uv pip
export alias cls = clear
export alias lzd = lazydocker
export alias my-http-server = my-http-server --port (port)
