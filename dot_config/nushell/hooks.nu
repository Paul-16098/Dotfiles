const self = path self

# Edit this config.
export def "config user-hooks" []: nothing -> nothing {
  run-external $env.config.buffer_editor ($self)
}

use std/config *

export-env {
  # Initialize the PWD hook as an empty list if it doesn't exist
  $env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []

  $env.config.hooks.env_change.PWD ++= [
    {||
      if (which direnv | is-empty) {
        # If direnv isn't installed, do nothing
        return
      }

      try { direnv export json | from json } | default {} | update cells --columns [PATH] {
        # If direnv changes the PATH, it will become a string and we need to re-convert it to a list
        do (env-conversions).path.from_string $in
      } | load-env
    }
  ]
}
