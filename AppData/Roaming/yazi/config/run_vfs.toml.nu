let rclone_vfs = {
  rclone: (
    # nu-lint-ignore: catch_builtin_error_try
    rclone config dump | from json | record each {|k v|
      {
        $k: {
          kind : mount
          run : rclone
          root : /

          backend: $v
        }
      }
    }
  )
}

let vfs = try { open ~\AppData\Roaming\yazi\config\vfs.toml } | default {}
  | merge deep --strategy overwrite $rclone_vfs
$vfs | save ~\AppData\Roaming\yazi\config\vfs.toml --force # nu-lint-ignore: catch_builtin_error_try

# let bookmarks = try { open ~\AppData\Roaming\yazi\config\bookmarks } | default '' | lines | parse --regex "(?<tag>.+)\t(?<path>.+)\t(?<key>.*)" # nu-lint-ignore: default_empty_string_masks_missing

# $bookmarks ++ (
#   $vfs.rclone | record each {|k v|
#     [
#       $"rclone: ($k)"
#       {
#         tag: $"rclone: ($k)"
#         path: $"rclone://($k)"
#         key: ''
#       }
#     ]
#   } | values
# ) | each { $"($in.tag)\t($in.path)\t($in.key)" } | str join (char newline) | save --force ~\AppData\Roaming\yazi\config\bookmarks # nu-lint-ignore: catch_builtin_error_try
