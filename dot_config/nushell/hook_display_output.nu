const self = path self

# Edit this config.
export def "config user-display-output" []: nothing -> nothing {
  run-external $env.config.buffer_editor ($self)
}

# nu-lint-ignore: unused_helper_functions
def classify []: record -> record {
  let md = $in
  # print --stderr ($md | to json)
  let head = try { view span $md.span.start $md.span.end }
  match $md.content_type? {
    null => {table: true}
    $mimetype if $mimetype starts-with 'image' => {image: true}
    $mimetype if ($mimetype starts-with 'video' or $mimetype starts-with 'audio') => {video: true}
    "application/x-nuscript" | "application/x-nuon" | "text/x-nushell" => {nu: true}
    _ => {table: true}
  }
  | insert head $head
  | insert source $md.source?
  # | tee { print --stderr $in }
}

export-env {
  $env.config.hooks.display_output = {
    metadata access {|meta|
      do {|class|
        match $class {
          {nu: true} => { nu-highlight }
          # {head: ls} => { sort-by type modified size name --custom {|a b| $a == dir } }
          # {head: ps} => { move pid ppid --last | sort-by mem virtual cpu --reverse }
          _ => { }
        }
        | match $class {
          # {video: true} | {image: true} => {
          #   ^($env.ProgramFiles | path join VideoLAN\VLC\vlc.exe) -
          # }

          $data => {
            table --expand=((term size).columns >= 100) --icons=(($data.head) == "ls")
          }
        }
      } ($meta | classify)
    }
  }
}
