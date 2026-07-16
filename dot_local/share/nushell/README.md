<!-- markdownlint-disable-file MD060 -->

# doc By numd

> By numd

## user-fn

<!-- numd-gen-start: use numd;use ./user-fn.nu; numd doc 'user-fn' -->
### `user-fn _atuin history`

a wrapper for atuin history command to output a table with date, duration, exit code and command, also parse the duration to a duration type and exit code to int, also highlight the command using nu-highlight

```nushell no-run
user-fn _atuin history    # `nothing -> table`
```

**Flags:**

- `--limit: int` (default: `500`)
- `--reverse`

### `user-fn alternative-buffer`

alternative buffer wrapper, use callback to run commands in alternative buffer and get the output, the callback should return the output as a string, the alternative buffer will be cleared after the callback is executed
nu-lint-ignore: missing_in_type, missing_output_type

```nushell no-run
user-fn alternative-buffer <fn> ...()
```

**Parameters:**

- `fn: closure()` — a callback to run commands in alternative buffer, the callback should return the output as a string
- `...: any` — a rest to pass to the callback

**Flags:**

- `--keep-env` — Keep the environment defined inside the command.
nu-lint-ignore: add_type_hints_arguments

### `user-fn app-update`

for each app update job, check if the update is enabled in the config before spawning the job, the config should be a record with app names as keys and a record with status on/off as values, e.g. {app-update-nu: {status: on}, app-update-rustup: {status: off}}

```nushell no-run
user-fn app-update (cofg)
```

**Parameters:**

- `(cofg): record` — the config record to check if the update job is enabled, should be a record with app names as keys and a record with status on/off as values, e.g. {app-update-nu: {status: on}, app-update-rustup: {status: off}}

**Flags:**

- `--bel-at-end` — if set, ring the bell after all updates are completed

### `user-fn chezmoi cd`

https://www.chezmoi.io/user-guide/frequently-asked-questions/design/#why-does-chezmoi-cd-spawn-a-shell-instead-of-just-changing-directory

```nushell no-run
user-fn chezmoi cd
```

### `user-fn clip copy-image`

copy image to clipboard using powershell

```nushell no-run
user-fn clip copy-image ...(paths)    # `nothing -> nothing`
```

**Parameters:**

- `...paths: path` — paths of images to copy to clipboard

### `user-fn config user-fn`

Edit this config.

```nushell no-run
user-fn config user-fn    # `nothing -> nothing`
```

### `user-fn docker compose ls`

wrapper for docker compose commands to output json parsed tables

```nushell no-run
user-fn docker compose ls ...()    # `nothing -> table`
```

**Parameters:**

- `...: string`

### `user-fn docker compose ps`

wrapper for docker compose ps to output json parsed table and format RunningFor column to human readable date

```nushell no-run
user-fn docker compose ps ...()    # `nothing -> table`
```

**Parameters:**

- `...: string`

### `user-fn docker compose stats`

wrapper for docker compose stats to output json parsed table, also add --no-trunc and --no-stream to get full output and only one snapshot

```nushell no-run
user-fn docker compose stats ...()    # `nothing -> table`
```

**Parameters:**

- `...: string`

### `user-fn docker compose version`

wrapper for docker compose version to output json parsed record

```nushell no-run
user-fn docker compose version ...()    # `nothing -> record`
```

**Parameters:**

- `...: string`

### `user-fn docker compose volumes`

wrapper for docker volumes to output json parsed table

```nushell no-run
user-fn docker compose volumes ...()    # `nothing -> table`
```

**Parameters:**

- `...: string`

### `user-fn es`

es wrapper to always output json parsed table

```nushell no-run
user-fn es ...()    # `nothing -> table`
```

**Parameters:**

- `...: string`

### `user-fn get-dll`

get dll dependencies of an exe file

```nushell no-run
user-fn get-dll <exe_file>    # `nothing -> table<command: string, path?: string>`
```

**Parameters:**

- `exe_file: path` — the exe file to analyze

### `user-fn git log`

git log wrapper to format output as a table

noreply email is filtered out
merge commit messages are reformatted to include links
commit messages are highlighted for common prefixes
version tags are highlighted
no sort

```nushell no-run
user-fn git log ...()    # `nothing -> table`
```

**Parameters:**

- `...: string`

### `user-fn git pull`

git pull wrapper to show updated commits
and add hooks for pre-pull and post-pull scripts if they exist in .git/hooks/pre-pull and .git/hooks/post-pull, also add options to skip hooks and skip pause, and add config to disable the wrapper for specific repos or specific commit subjects, if the pull includes commits with subjects that match the configured ones, skip the interactive prompt and directly pull, also handle the case when there is no tracking information for the current branch and show a helpful error message

```nushell no-run
user-fn git pull ...()    # `nothing -> nothing`
```

**Parameters:**

- `...: string`

**Flags:**

- `--no-pause` — if set, skip the interactive prompt and directly pull, useful for automation or when the user is confident about the changes being pulled
- `--no-hooks` — if set, skip running pre-pull and post-pull hooks

### `user-fn git show`

git show wrapper to handle the case when git show is interrupted by user (exit code 141) to avoid showing error message

```nushell no-run
user-fn git show ...()    # `any -> string`
```

**Parameters:**

- `...: string`

### `user-fn git status-or-show`

a wrapper for git status and git show, if no arguments, run git status, otherwise run git show with the provided arguments, also handle the case when git show is interrupted by user (exit code 141) to avoid showing error message

```nushell no-run
user-fn git status-or-show ...()    # `any -> string`
```

**Parameters:**

- `...: string`

### `user-fn highlight`

use $color_code to highlight text in output

```nushell no-run
user-fn highlight ...(highlight_text)    # `string -> string`
```

**Parameters:**

- `...highlight_text: string` — text to highlight in output, can not include regex special characters

**Flags:**

- `--color-code (-c): string` — use in ansi $color_code to highlight text, hex string or color name supported (default: `"red_bold"`)
- `--regex (-r)` — if set, treat highlight_text as regex pattern, otherwise treat it as plain text, default is false

**Examples:**

highlight with text

```nushell no-run
"abc" | highlight "a"
# => abc
```

highlight with 2 text

```nushell no-run
"abc" | highlight "a" "c"
# => abc
```

highlight with regex

```nushell no-run
"abc" | highlight --regex "^a.*$"
# => abc
```

### `user-fn meme`

get meme and copy to clipboard

```nushell no-run
user-fn meme (type)    # `nothing -> nothing`
```

**Parameters:**

- `(type): string` — what tool to use to pick meme

### `user-fn netstat -ano`

a wrapper for netstat -ano to output a table with Proto, Local Address, Foreign Address, State and PID columns, also parse the PID to int and filter out the first 3 lines of the output

```nushell no-run
user-fn netstat -ano    # `nothing -> table`
```

### `user-fn pause`

my custom pause function

```nushell no-run
user-fn pause    # `nothing -> nothing`
```

### `user-fn ps name`

a wrapper for ps command to filter processes by name, use ps to get the process information, then filter the processes by name using regex match, also pass the rest arguments to ps command

```nushell no-run
user-fn ps name <name>    # `nothing -> table`
```

**Parameters:**

- `name: string`

**Flags:**

- `--long (-l)`

### `user-fn ps port`

a wrapper for ps command to filter processes by port, only implemented for windows, use netstat -ano to get the PID of the process listening on the specified port, then use ps to get the process information, also pass the rest arguments to ps command

```nushell no-run
user-fn ps port <port>    # `nothing -> table`
```

**Parameters:**

- `port: int`

**Flags:**

- `--long (-l)`

### `user-fn reload-config`

used in keybindings.nu for F5

```nushell no-run
user-fn reload-config    # `nothing -> string`
```

### `user-fn set-debug-env`

set debug env variables
use as `with-env (set-debug-env --log-lv debug --backtrace full) { ... }`

```nushell no-run
user-fn set-debug-env    # `nothing -> record`
```

**Flags:**

- `--rust-log-lv: string` — set RUST_LOG level
- `--rust-backtrace: string` — set RUST_BACKTRACE level
- `--nu-log-lv: int` — set nu std/log level

### `user-fn steamcmd`

steamcmd wrapper to login

```nushell no-run
user-fn steamcmd ...(args)    # `nothing -> nothing`
```

**Parameters:**

- `...args: string` — +COMMAND [ARG]...

**Flags:**

- `--REPL` — if set, run steamcmd in interactive mode, otherwise run with provided arguments, default is false

### `user-fn whois`

whois wrapper to format output as a table

```nushell no-run
user-fn whois ...()    # `nothing -> table`
```

**Parameters:**

- `...: string` — a rest that to whois-cli

**Flags:**

- `--use-akae_re_api` — use whois.akae.re API to get whois information

### `user-fn y`

https://yazi-rs.github.io/docs/quick-start#shell-wrapper

```nushell no-run
user-fn y ...(args)    # `nothing -> nothing`
```

**Parameters:**

- `...args: string`

**Flags:**

- `--skip-check-is-yazi` — if set, skip the check for YAZI_LEVEL environment variable, useful for advanced users who want to call yazi from another wrapper function, default is false
<!-- numd-gen-end -->

## keybindings

<!-- numd-gen-start: def reload-config [] {};def _atuin_search_cmd [...rest] {};use ./keybindings.nu;$env.config.keybindings | sort | to md -->
| name | modifier | keycode | event | mode |
| --- | --- | --- | --- | --- |
| add-default-keybinding | CONTROL | Backspace | {edit: BackspaceWord} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | CONTROL | Delete | {edit: DeleteWord} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | CONTROL | Left | {edit: MoveWordLeft} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | CONTROL | Right | {until: [{send: HistoryHintWordComplete}, {edit: MoveWordRight}]} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | CONTROL | char_a | {edit: SelectAll} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | CONTROL | char_c | {edit: CopySelectionSystem} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | CONTROL | char_c | {send: CtrlC} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | CONTROL | char_d | {send: CtrlD} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | CONTROL | char_o | {send: OpenEditor} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | CONTROL | char_v | {edit: PasteSystem} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | CONTROL | char_x | {edit: CutSelectionSystem} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | CONTROL | char_z | {edit: Undo} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | CONTROL_SHIFT | Left | {edit: MoveWordLeft, select: true} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | CONTROL_SHIFT | Right | {edit: MoveWordRight, select: true} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | SHIFT | Down | {edit: MoveLineDown, select: true} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | SHIFT | Enter | {edit: InsertNewline} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | SHIFT | Left | {edit: MoveLeft, select: true} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | SHIFT | Right | {edit: MoveRight, select: true} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | SHIFT | Up | {edit: MoveLineUp, select: true} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | none | Backspace | {edit: Backspace} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | none | Delete | {edit: Delete} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | none | Down | {until: [{send: MenuDown}, {send: executehostcommand, cmd:  commandline edit --replace ''}]} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | none | End | {edit: MoveToLineEnd} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | none | Enter | {send: Enter} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | none | Esc | {send: Esc} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | none | Home | {edit: MoveToLineStart} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | none | Left | {until: [{send: MenuLeft}, {send: Left}]} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | none | Right | {until: [{send: HistoryHintComplete}, {send: MenuRight}, {send: Right}]} | [emacs, vi_normal, vi_insert] |
| add-default-keybinding | none | Up | {until: [{send: MenuUp}, {send: executehostcommand, cmd: }]} | [emacs, vi_normal, vi_insert] |
| clear-screen | control | char_l | {send: ClearScreen} | [emacs, vi_normal, vi_insert] |
| clear-scrollback | control_shift | char_l | {send: ClearScrollBack} | [emacs, vi_normal, vi_insert] |
| custom-keybinding | CONTROL | Down | {edit: MoveLineDown} | [emacs, vi_normal, vi_insert] |
| custom-keybinding | CONTROL | Up | {edit: MoveLineUp} | [emacs, vi_normal, vi_insert] |
| custom-keybinding | control_shift | char_z | {edit: Redo} | [emacs, vi_normal, vi_insert] |
| exit-nu | control | char_d | {send: executehostcommand, cmd:  exit 0} | [emacs, vi_normal, vi_insert] |
| reload-config | none | f5 | {send: executehostcommand, cmd: } | [emacs, vi_normal, vi_insert] |
| remove-keybindings | ALT | Backspace |  | [emacs] |
| remove-keybindings | ALT | Delete |  | [emacs] |
| remove-keybindings | ALT | Enter |  | [emacs] |
| remove-keybindings | ALT | Enter |  | [vi_insert] |
| remove-keybindings | ALT | Left |  | [emacs] |
| remove-keybindings | ALT | Right |  | [emacs] |
| remove-keybindings | ALT | char_< |  | [emacs] |
| remove-keybindings | ALT | char_< |  | [vi_insert] |
| remove-keybindings | ALT | char_< |  | [vi_normal] |
| remove-keybindings | ALT | char_> |  | [emacs] |
| remove-keybindings | ALT | char_> |  | [vi_insert] |
| remove-keybindings | ALT | char_> |  | [vi_normal] |
| remove-keybindings | ALT | char_b |  | [emacs] |
| remove-keybindings | ALT | char_c |  | [emacs] |
| remove-keybindings | ALT | char_d |  | [emacs] |
| remove-keybindings | ALT | char_f |  | [emacs] |
| remove-keybindings | ALT | char_l |  | [emacs] |
| remove-keybindings | ALT | char_m |  | [emacs] |
| remove-keybindings | ALT | char_u |  | [emacs] |
| remove-keybindings | CONTROL | Backspace |  | [emacs] |
| remove-keybindings | CONTROL | Backspace |  | [vi_insert] |
| remove-keybindings | CONTROL | Delete |  | [emacs] |
| remove-keybindings | CONTROL | Delete |  | [vi_insert] |
| remove-keybindings | CONTROL | End |  | [emacs] |
| remove-keybindings | CONTROL | End |  | [vi_insert] |
| remove-keybindings | CONTROL | End |  | [vi_normal] |
| remove-keybindings | CONTROL | Home |  | [emacs] |
| remove-keybindings | CONTROL | Home |  | [vi_insert] |
| remove-keybindings | CONTROL | Home |  | [vi_normal] |
| remove-keybindings | CONTROL | Left |  | [emacs] |
| remove-keybindings | CONTROL | Left |  | [vi_insert] |
| remove-keybindings | CONTROL | Left |  | [vi_normal] |
| remove-keybindings | CONTROL | Right |  | [emacs] |
| remove-keybindings | CONTROL | Right |  | [vi_insert] |
| remove-keybindings | CONTROL | Right |  | [vi_normal] |
| remove-keybindings | CONTROL | char_a |  | [emacs] |
| remove-keybindings | CONTROL | char_a |  | [vi_insert] |
| remove-keybindings | CONTROL | char_a |  | [vi_normal] |
| remove-keybindings | CONTROL | char_b |  | [emacs] |
| remove-keybindings | CONTROL | char_c |  | [emacs] |
| remove-keybindings | CONTROL | char_c |  | [vi_insert] |
| remove-keybindings | CONTROL | char_c |  | [vi_normal] |
| remove-keybindings | CONTROL | char_d |  | [emacs] |
| remove-keybindings | CONTROL | char_d |  | [vi_insert] |
| remove-keybindings | CONTROL | char_d |  | [vi_normal] |
| remove-keybindings | CONTROL | char_e |  | [emacs] |
| remove-keybindings | CONTROL | char_e |  | [vi_insert] |
| remove-keybindings | CONTROL | char_e |  | [vi_normal] |
| remove-keybindings | CONTROL | char_f |  | [emacs] |
| remove-keybindings | CONTROL | char_g |  | [emacs] |
| remove-keybindings | CONTROL | char_h |  | [emacs] |
| remove-keybindings | CONTROL | char_h |  | [vi_insert] |
| remove-keybindings | CONTROL | char_j |  | [emacs] |
| remove-keybindings | CONTROL | char_j |  | [vi_insert] |
| remove-keybindings | CONTROL | char_k |  | [emacs] |
| remove-keybindings | CONTROL | char_l |  | [emacs] |
| remove-keybindings | CONTROL | char_l |  | [vi_insert] |
| remove-keybindings | CONTROL | char_l |  | [vi_normal] |
| remove-keybindings | CONTROL | char_n |  | [emacs] |
| remove-keybindings | CONTROL | char_n |  | [vi_insert] |
| remove-keybindings | CONTROL | char_n |  | [vi_normal] |
| remove-keybindings | CONTROL | char_o |  | [emacs] |
| remove-keybindings | CONTROL | char_o |  | [vi_insert] |
| remove-keybindings | CONTROL | char_o |  | [vi_normal] |
| remove-keybindings | CONTROL | char_p |  | [emacs] |
| remove-keybindings | CONTROL | char_p |  | [vi_insert] |
| remove-keybindings | CONTROL | char_p |  | [vi_normal] |
| remove-keybindings | CONTROL | char_r |  | [emacs] |
| remove-keybindings | CONTROL | char_r |  | [vi_insert] |
| remove-keybindings | CONTROL | char_r |  | [vi_normal] |
| remove-keybindings | CONTROL | char_t |  | [emacs] |
| remove-keybindings | CONTROL | char_u |  | [emacs] |
| remove-keybindings | CONTROL | char_w |  | [emacs] |
| remove-keybindings | CONTROL | char_w |  | [vi_insert] |
| remove-keybindings | CONTROL | char_y |  | [emacs] |
| remove-keybindings | CONTROL | char_z |  | [emacs] |
| remove-keybindings | SHIFT | Down |  | [emacs] |
| remove-keybindings | SHIFT | Down |  | [vi_insert] |
| remove-keybindings | SHIFT | Down |  | [vi_normal] |
| remove-keybindings | SHIFT | End |  | [emacs] |
| remove-keybindings | SHIFT | End |  | [vi_insert] |
| remove-keybindings | SHIFT | End |  | [vi_normal] |
| remove-keybindings | SHIFT | Enter |  | [emacs] |
| remove-keybindings | SHIFT | Enter |  | [vi_insert] |
| remove-keybindings | SHIFT | Home |  | [emacs] |
| remove-keybindings | SHIFT | Home |  | [vi_insert] |
| remove-keybindings | SHIFT | Home |  | [vi_normal] |
| remove-keybindings | SHIFT | Left |  | [emacs] |
| remove-keybindings | SHIFT | Left |  | [vi_insert] |
| remove-keybindings | SHIFT | Left |  | [vi_normal] |
| remove-keybindings | SHIFT | Right |  | [emacs] |
| remove-keybindings | SHIFT | Right |  | [vi_insert] |
| remove-keybindings | SHIFT | Right |  | [vi_normal] |
| remove-keybindings | SHIFT | Up |  | [emacs] |
| remove-keybindings | SHIFT | Up |  | [vi_insert] |
| remove-keybindings | SHIFT | Up |  | [vi_normal] |
| remove-keybindings | SHIFT_ALT | char_, |  | [emacs] |
| remove-keybindings | SHIFT_ALT | char_, |  | [vi_insert] |
| remove-keybindings | SHIFT_ALT | char_, |  | [vi_normal] |
| remove-keybindings | SHIFT_ALT | char_. |  | [emacs] |
| remove-keybindings | SHIFT_ALT | char_. |  | [vi_insert] |
| remove-keybindings | SHIFT_ALT | char_. |  | [vi_normal] |
| remove-keybindings | SHIFT_CONTROL | End |  | [emacs] |
| remove-keybindings | SHIFT_CONTROL | End |  | [vi_insert] |
| remove-keybindings | SHIFT_CONTROL | End |  | [vi_normal] |
| remove-keybindings | SHIFT_CONTROL | Home |  | [emacs] |
| remove-keybindings | SHIFT_CONTROL | Home |  | [vi_insert] |
| remove-keybindings | SHIFT_CONTROL | Home |  | [vi_normal] |
| remove-keybindings | SHIFT_CONTROL | Left |  | [emacs] |
| remove-keybindings | SHIFT_CONTROL | Left |  | [vi_insert] |
| remove-keybindings | SHIFT_CONTROL | Left |  | [vi_normal] |
| remove-keybindings | SHIFT_CONTROL | Right |  | [emacs] |
| remove-keybindings | SHIFT_CONTROL | Right |  | [vi_insert] |
| remove-keybindings | SHIFT_CONTROL | Right |  | [vi_normal] |
| remove-keybindings | SHIFT_CONTROL | char_a |  | [emacs] |
| remove-keybindings | SHIFT_CONTROL | char_a |  | [vi_insert] |
| remove-keybindings | SHIFT_CONTROL | char_a |  | [vi_normal] |
| remove-keybindings | SHIFT_CONTROL | char_c |  | [emacs] |
| remove-keybindings | SHIFT_CONTROL | char_c |  | [vi_insert] |
| remove-keybindings | SHIFT_CONTROL | char_v |  | [emacs] |
| remove-keybindings | SHIFT_CONTROL | char_v |  | [vi_insert] |
| remove-keybindings | SHIFT_CONTROL | char_x |  | [emacs] |
| remove-keybindings | SHIFT_CONTROL | char_x |  | [vi_insert] |
| remove-keybindings | none | Backspace |  | [emacs] |
| remove-keybindings | none | Backspace |  | [vi_insert] |
| remove-keybindings | none | Backspace |  | [vi_normal] |
| remove-keybindings | none | Delete |  | [emacs] |
| remove-keybindings | none | Delete |  | [vi_insert] |
| remove-keybindings | none | Delete |  | [vi_normal] |
| remove-keybindings | none | Down |  | [emacs] |
| remove-keybindings | none | Down |  | [vi_insert] |
| remove-keybindings | none | Down |  | [vi_normal] |
| remove-keybindings | none | End |  | [emacs] |
| remove-keybindings | none | End |  | [vi_insert] |
| remove-keybindings | none | End |  | [vi_normal] |
| remove-keybindings | none | Enter |  | [emacs] |
| remove-keybindings | none | Esc |  | [emacs] |
| remove-keybindings | none | Esc |  | [vi_insert] |
| remove-keybindings | none | Esc |  | [vi_normal] |
| remove-keybindings | none | Home |  | [emacs] |
| remove-keybindings | none | Home |  | [vi_insert] |
| remove-keybindings | none | Home |  | [vi_normal] |
| remove-keybindings | none | Left |  | [emacs] |
| remove-keybindings | none | Left |  | [vi_insert] |
| remove-keybindings | none | Left |  | [vi_normal] |
| remove-keybindings | none | Right |  | [emacs] |
| remove-keybindings | none | Right |  | [vi_insert] |
| remove-keybindings | none | Right |  | [vi_normal] |
| remove-keybindings | none | Up |  | [emacs] |
| remove-keybindings | none | Up |  | [vi_insert] |
| remove-keybindings | none | Up |  | [vi_normal] |
| search-atuin-history | control | char_/ | {send: executehostcommand, cmd: } | [emacs, vi_normal, vi_insert] |
| yazi-menu | control | char_\\ | {send: executehostcommand, cmd:  y} | [emacs, vi_normal, vi_insert] |
<!-- numd-gen-end -->
