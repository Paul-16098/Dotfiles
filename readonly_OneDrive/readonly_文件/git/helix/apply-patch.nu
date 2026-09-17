# apply patch from gh pr and local
export def main []: nothing -> table {
  mut patch = []

  git reset origin/HEAD --hard
  git clean -f

  $patch ++= glob ../helix-patch/*.nu | each {
      print --stderr $"run patch script ($in)"
      nu $in
    } | where ($it | is-not-empty)

  $patch ++= glob ../helix-patch/*.patch | par-each --keep-order {
      print --stderr $"read patch ($in)"
      open $in # nu-lint-ignore: catch_builtin_error_try
    }

  $patch ++= open ../helix-patch/http-patch.json # nu-lint-ignore: catch_builtin_error_try
    | par-each --keep-order {
      print --stderr $"get http patch ($in)"
      http $in # nu-lint-ignore: catch_builtin_error_try
    }

  $patch | each { git apply - -vvv | complete } | tee {if ($in | any {$in.exit_code != 0}) {print --stderr (char bel)}}
}
