<!-- markdownlint-disable-file MD060 -->

# doc By numd

> By numd

## user-fn

<!-- numd-gen-start: use numd;use ./user-fn.nu; numd doc 'user-fn' -->
### `user-fn _atuin history list`

a wrapper for atuin history list command to output a table with date, duration, exit code and command, also parse the duration to a duration type and exit code to int, also highlight the command using nu-highlight

```nushell no-run
user-fn _atuin history list    # `nothing -> table`
```

**Flags:**

- `--reverse`
- `--limit (-n): int` — limit the number of history entries to show (default: `100`)

### `user-fn aic`

aic wrapper to run ollama server and then run aic command, if ollama server is already running, it will not start a new server
in tui mode, it need tty to run

```nushell no-run
user-fn aic ...()    # `nothing -> nothing`
```

**Parameters:**

- `...: string`

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

### `user-fn ast get-last-command`

get the last command from the input string
WARN: the sigil like `^` and `%` will be removed from the command

```nushell no-run
user-fn ast get-last-command (input)    # `nothing -> string`, `string -> string`
```

**Parameters:**

- `(input): string`

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

### `user-fn gh api`

a wrapper for gh api command to output json parsed, if the output is invalid json, return string

```nushell no-run
user-fn gh api ...()    # `nothing -> oneof<table, record>`, `nothing -> string`
```

**Parameters:**

- `...: string`

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

### `user-fn git status-or-diff`

a wrapper for git status and git show, if no arguments, run git status, otherwise run git show with the provided arguments, also handle the case when git show is interrupted by user (exit code 141) to avoid showing error message

```nushell no-run
user-fn git status-or-diff ...()    # `any -> string`
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

### `user-fn input ask-yn`

ask user for yes or no input, if default_choice is set, use it as the default choice, if user input is invalid, return null
the prompt will impl by call and not in this function
the return value is one of true, false or null, if null, the caller should handle the invalid input and ask again

```nushell no-run
user-fn input ask-yn (default_choice)    # `nothing -> oneof<bool, nothing>`
```

**Parameters:**

- `(default_choice): bool`

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

### `user-fn ollama wrapper-if-not-run`

an wrapper to run ollama server and then run a callback function, if ollama server is already running, it will not start a new server, the callback function should return the output as a string
nu-lint-ignore: missing_in_type, missing_output_type, add_type_hints_arguments

```nushell no-run
user-fn ollama wrapper-if-not-run <fn> ...()
```

**Parameters:**

- `fn: closure()`
- `...: any`

**Flags:**

- `--log-to-stderr` — if set, log the output of ollama server to stderr

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
- `--yazi-log-lv: string` — set yazi log level

### `user-fn steamcmd`

steamcmd wrapper to login

```nushell no-run
user-fn steamcmd ...(args)    # `nothing -> nothing`
```

**Parameters:**

- `...args: string` — +COMMAND [ARG]...

**Flags:**

- `--REPL` — if set, run steamcmd in interactive mode, otherwise run with provided arguments, default is false

### `user-fn what-def`

get the definition of a function in a nushell file, return a record with the function name and the definition, if the function is not found, return an error

```nushell no-run
user-fn what-def <file>    # `nothing -> record`
```

**Parameters:**

- `file: path`

### `user-fn whois`

whois wrapper to format output as a table

```nushell no-run
user-fn whois ...()    # `nothing -> table`
```

**Parameters:**

- `...: string` — a rest that to whois-cli

**Flags:**

- `--use-akae_re_api` — use whois.akae.re API to get whois information
- `--raw` — if set, return raw output from whois-cli

### `user-fn y`

yazi wrapper to watch for local and remote events

```nushell no-run
user-fn y ...(args)    # `nothing -> oneof<nothing`
```

**Parameters:**

- `...args: external-argument`

**Flags:**

- `--skip-check-is-yazi` — if set, skip the check for YAZI_LEVEL environment variable, useful for advanced users who want to call yazi from another wrapper function
- `--watch-events` — if set, watch for local and remote events
<!-- numd-gen-end -->

## keybindings

<!-- numd-gen-start: def reload-config [] {};def _atuin_search_cmd [...rest] {};use ./keybindings.nu;$env.config.keybindings | sort | to md -->
| name | modifier | keycode | event | mode |
| --- | --- | --- | --- | --- |
| clear-screen | control | char_l | {send: ClearScreen} | [emacs, vi_normal, vi_insert] |
| clear-scrollback | control_shift | char_l | {send: ClearScrollBack} | [emacs, vi_normal, vi_insert] |
| exit-nu | control | char_d | {send: executehostcommand, cmd:  exit 0} | [emacs, vi_normal, vi_insert] |
| help | control | char_h | {send: executehostcommand, cmd:  print '';help $'(commandline\|str trim)'} | [emacs, vi_normal, vi_insert] |
| reload-config | none | f5 | {send: executehostcommand, cmd: } | [emacs, vi_normal, vi_insert] |
| search-atuin-history | control | char_/ | {send: executehostcommand, cmd: } | [emacs, vi_normal, vi_insert] |
| yazi-menu | control | char_\\ | {send: executehostcommand, cmd:  y} | [emacs, vi_normal, vi_insert] |
|  | CONTROL | Backspace | {edit: BackspaceWord} | [emacs, vi_normal, vi_insert] |
|  | CONTROL | Delete | {edit: DeleteWord} | [emacs, vi_normal, vi_insert] |
|  | CONTROL | Down | {edit: MoveLineDown} | [emacs, vi_normal, vi_insert] |
|  | CONTROL | Left | {edit: MoveWordLeft} | [emacs, vi_normal, vi_insert] |
|  | CONTROL | Right | {until: [{send: HistoryHintWordComplete}, {edit: MoveWordRight}]} | [emacs, vi_normal, vi_insert] |
|  | CONTROL | Up | {edit: MoveLineUp} | [emacs, vi_normal, vi_insert] |
|  | CONTROL | char_a | {edit: SelectAll} | [emacs, vi_normal, vi_insert] |
|  | CONTROL | char_c | {until: [{edit: CopySelectionSystem}, {send: CtrlC}]} | [emacs, vi_normal, vi_insert] |
|  | CONTROL | char_o | {send: OpenEditor} | [emacs, vi_normal, vi_insert] |
|  | CONTROL | char_v | {edit: PasteSystem} | [emacs, vi_normal, vi_insert] |
|  | CONTROL | char_x | {edit: CutSelectionSystem} | [emacs, vi_normal, vi_insert] |
|  | CONTROL | char_z | {edit: Undo} | [emacs, vi_normal, vi_insert] |
|  | CONTROL_SHIFT | Left | {edit: MoveWordLeft, select: true} | [emacs, vi_normal, vi_insert] |
|  | CONTROL_SHIFT | Right | {edit: MoveWordRight, select: true} | [emacs, vi_normal, vi_insert] |
|  | SHIFT | Down | {edit: MoveLineDown, select: true} | [emacs, vi_normal, vi_insert] |
|  | SHIFT | Enter | {edit: InsertNewline} | [emacs, vi_normal, vi_insert] |
|  | SHIFT | Left | {edit: MoveLeft, select: true} | [emacs, vi_normal, vi_insert] |
|  | SHIFT | Right | {edit: MoveRight, select: true} | [emacs, vi_normal, vi_insert] |
|  | SHIFT | Up | {edit: MoveLineUp, select: true} | [emacs, vi_normal, vi_insert] |
|  | control_shift | char_z | {edit: Redo} | [emacs, vi_normal, vi_insert] |
|  | none | Backspace | {edit: Backspace} | [emacs, vi_normal, vi_insert] |
|  | none | Delete | {edit: Delete} | [emacs, vi_normal, vi_insert] |
|  | none | Down | {until: [{send: MenuDown}, {send: executehostcommand, cmd:  commandline edit --replace ''}]} | [emacs, vi_normal, vi_insert] |
|  | none | End | {edit: MoveToLineEnd} | [emacs, vi_normal, vi_insert] |
|  | none | Enter | {send: Enter} | [emacs, vi_normal, vi_insert] |
|  | none | Esc | {send: Esc} | [emacs, vi_normal, vi_insert] |
|  | none | Home | {edit: MoveToLineStart} | [emacs, vi_normal, vi_insert] |
|  | none | Left | {until: [{send: MenuLeft}, {send: Left}]} | [emacs, vi_normal, vi_insert] |
|  | none | Right | {until: [{send: HistoryHintComplete}, {send: MenuRight}, {send: Right}]} | [emacs, vi_normal, vi_insert] |
|  | none | Up | {until: [{send: MenuUp}, {send: executehostcommand, cmd: }]} | [emacs, vi_normal, vi_insert] |
|  | none | tab | {until: [{send: menu, name: completion_menu}, {send: menunext}, {edit: complete}]} | [emacs, vi_normal, vi_insert] |
<!-- numd-gen-end -->
