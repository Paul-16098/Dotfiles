@structured [--json] { from json }
@complete external
export extern es []

const ATUIN_LIST_FORMAT = "{user}\t{host}\t{directory}\t{time}\t{duration}\t{exit}\t{command}"
@structured [--format=($ATUIN_LIST_FORMAT)] {
  lines
  | parse $ATUIN_LIST_FORMAT
  | str replace --regex '^(\d+)s$' '$1sec' duration # nu-lint-ignore: chained_str_transform
  | str replace --regex '^(\d+)m$' '$1min' duration
  | str replace --regex '^(\d+)h$' '$1hr' duration
  | record apply {
    time: { into datetime }
    exit: { into int }
    command: { nu-highlight }
    duration: { into duration }
  }
}
@complete external
export extern "atuin history list" []

@structured [] { from json }
@complete external
export extern 'gh api' []
