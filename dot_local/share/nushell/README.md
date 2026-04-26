# doc By numd

> By numd

## user-fn

```nu s
use ./user-fn.nu
ls-commands user-fn | to md
```

Output:

```
# => | name | description |
# => | --- | --- |
# => | _atuin history | a wrapper for atuin history command to output a table with date, duration, exit code and command, also parse the duration to a duration type and exit code to int, also highlight the command using nu-highlight |
# => | alternative-buffer | alternative buffer wrapper, use callback to run commands in alternative buffer and get the output, the callback should return the output as a string, the alternative buffer will be cleared after the callback is executed
# => nu-lint-ignore: missing_in_type, missing_output_type |
# => | app-update | for each app update job, check if the update is enabled in the config before spawning the job, the config should be a record with app names as keys and a record with status on/off as values, e.g. {app-update-nu: {status: on}, app-update-rustup: {status: off}} |
# => | chezmoi cd | https://www.chezmoi.io/user-guide/frequently-asked-questions/design/#why-does-chezmoi-cd-spawn-a-shell-instead-of-just-changing-directory |
# => | clip copy-image | copy image to clipboard using powershell |
# => | config user-fn | Edit this config. |
# => | docker compose ls | wrapper for docker compose commands to output json parsed tables |
# => | docker compose ps | wrapper for docker compose ps to output json parsed table and format RunningFor column to human readable date |
# => | docker compose stats | wrapper for docker compose stats to output json parsed table, also add --no-trunc and --no-stream to get full output and only one snapshot |
# => | docker compose version | wrapper for docker compose version to output json parsed record |
# => | docker compose volumes | wrapper for docker volumes to output json parsed table |
# => | es | es wrapper to always output json parsed table |
# => | gc | Alias for `git clone` |
# => | get-dll | get dll dependencies of an exe file |
# => | git log | git log wrapper to format output as a table |
# => | git pull | git pull wrapper to show updated commits |
# => | git status-or-show | a wrapper for git status and git show, if no arguments, run git status, otherwise run git show with the provided arguments, also handle the case when git show is interrupted by user (exit code 141) to avoid showing error message |
# => | gl | Alias for `git log` |
# => | gp | Alias for `git pull` |
# => | gs | Alias for `git status-or-show` |
# => | highlight | use $color_code to highlight text in output |
# => | kill with name | kill process by name |
# => | meme | get meme and copy to clipboard |
# => | pause | my custom pause function |
# => | reload-config | used in keybindings.nu for F5 |
# => | rust-debug | set rust debug env variables |
# => | steamcmd | steamcmd wrapper to login |
# => | vt scan file |  |
# => | whois | whois wrapper to format output as a table |
# => | y | https://yazi-rs.github.io/docs/quick-start#shell-wrapper |
```

## keybindings

```nu s
def reload-config [] {}
def _atuin_search_cmd [...rest] {}
use ./keybindings.nu
keybindings --help
$env.config.keybindings | sort | to md
```

Output:

```
# => | name | modifier | keycode | event | mode |
# => | --- | --- | --- | --- | --- |
# => | add-default-keybinding | CONTROL | Backspace | {edit: BackspaceWord} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | CONTROL | Delete | {edit: DeleteWord} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | CONTROL | Left | {edit: MoveWordLeft} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | CONTROL | Right | {until: [{send: HistoryHintWordComplete}, {edit: MoveWordRight}]} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | CONTROL | char_a | {edit: SelectAll} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | CONTROL | char_c | {edit: CopySelectionSystem} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | CONTROL | char_c | {send: CtrlC} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | CONTROL | char_d | {send: CtrlD} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | CONTROL | char_v | {edit: PasteSystem} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | CONTROL | char_x | {edit: CutSelectionSystem} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | CONTROL | char_z | {edit: Undo} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | CONTROL_SHIFT | Left | {edit: MoveWordLeft, select: true} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | CONTROL_SHIFT | Right | {edit: MoveWordRight, select: true} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | SHIFT | Down | {edit: MoveLineDown, select: true} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | SHIFT | Enter | {edit: InsertNewline} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | SHIFT | Left | {edit: MoveLeft, select: true} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | SHIFT | Right | {edit: MoveRight, select: true} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | SHIFT | Up | {edit: MoveLineUp, select: true} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | none | Backspace | {edit: Backspace} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | none | Delete | {edit: Delete} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | none | Down | {until: [{send: MenuDown}, {send: executehostcommand, cmd:  commandline edit --replace ''}]} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | none | End | {edit: MoveToLineEnd} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | none | Enter | {send: Enter} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | none | Esc | {send: Esc} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | none | Home | {edit: MoveToLineStart} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | none | Left | {until: [{send: MenuLeft}, {send: Left}]} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | none | Right | {until: [{send: HistoryHintComplete}, {send: MenuRight}, {send: Right}]} | [emacs, vi_normal, vi_insert] |
# => | add-default-keybinding | none | Up | {until: [{send: MenuUp}, {send: executehostcommand, cmd: }]} | [emacs, vi_normal, vi_insert] |
# => | clear-screen | control | char_l | {send: ClearScreen} | [emacs, vi_normal, vi_insert] |
# => | clear-scrollback | control_shift | char_l | {send: ClearScrollBack} | [emacs, vi_normal, vi_insert] |
# => | custom-keybinding | CONTROL | Down | {edit: MoveLineDown} | [emacs, vi_normal, vi_insert] |
# => | custom-keybinding | CONTROL | Up | {edit: MoveLineUp} | [emacs, vi_normal, vi_insert] |
# => | custom-keybinding | control_shift | char_z | {edit: Redo} | [emacs, vi_normal, vi_insert] |
# => | exit-nu | control | char_d | {send: executehostcommand, cmd:  exit 0} | [emacs, vi_normal, vi_insert] |
# => | reload-config | none | f5 | {send: executehostcommand, cmd: } | [emacs, vi_normal, vi_insert] |
# => | remove-keybindings | ALT | Backspace |  | [emacs] |
# => | remove-keybindings | ALT | Delete |  | [emacs] |
# => | remove-keybindings | ALT | Enter |  | [emacs] |
# => | remove-keybindings | ALT | Enter |  | [vi_insert] |
# => | remove-keybindings | ALT | Left |  | [emacs] |
# => | remove-keybindings | ALT | Right |  | [emacs] |
# => | remove-keybindings | ALT | char_< |  | [emacs] |
# => | remove-keybindings | ALT | char_< |  | [vi_insert] |
# => | remove-keybindings | ALT | char_< |  | [vi_normal] |
# => | remove-keybindings | ALT | char_> |  | [emacs] |
# => | remove-keybindings | ALT | char_> |  | [vi_insert] |
# => | remove-keybindings | ALT | char_> |  | [vi_normal] |
# => | remove-keybindings | ALT | char_b |  | [emacs] |
# => | remove-keybindings | ALT | char_c |  | [emacs] |
# => | remove-keybindings | ALT | char_d |  | [emacs] |
# => | remove-keybindings | ALT | char_f |  | [emacs] |
# => | remove-keybindings | ALT | char_l |  | [emacs] |
# => | remove-keybindings | ALT | char_m |  | [emacs] |
# => | remove-keybindings | ALT | char_u |  | [emacs] |
# => | remove-keybindings | CONTROL | Backspace |  | [emacs] |
# => | remove-keybindings | CONTROL | Backspace |  | [vi_insert] |
# => | remove-keybindings | CONTROL | Delete |  | [emacs] |
# => | remove-keybindings | CONTROL | Delete |  | [vi_insert] |
# => | remove-keybindings | CONTROL | End |  | [emacs] |
# => | remove-keybindings | CONTROL | End |  | [vi_insert] |
# => | remove-keybindings | CONTROL | End |  | [vi_normal] |
# => | remove-keybindings | CONTROL | Home |  | [emacs] |
# => | remove-keybindings | CONTROL | Home |  | [vi_insert] |
# => | remove-keybindings | CONTROL | Home |  | [vi_normal] |
# => | remove-keybindings | CONTROL | Left |  | [emacs] |
# => | remove-keybindings | CONTROL | Left |  | [vi_insert] |
# => | remove-keybindings | CONTROL | Left |  | [vi_normal] |
# => | remove-keybindings | CONTROL | Right |  | [emacs] |
# => | remove-keybindings | CONTROL | Right |  | [vi_insert] |
# => | remove-keybindings | CONTROL | Right |  | [vi_normal] |
# => | remove-keybindings | CONTROL | char_a |  | [emacs] |
# => | remove-keybindings | CONTROL | char_a |  | [vi_insert] |
# => | remove-keybindings | CONTROL | char_a |  | [vi_normal] |
# => | remove-keybindings | CONTROL | char_b |  | [emacs] |
# => | remove-keybindings | CONTROL | char_c |  | [emacs] |
# => | remove-keybindings | CONTROL | char_c |  | [vi_insert] |
# => | remove-keybindings | CONTROL | char_c |  | [vi_normal] |
# => | remove-keybindings | CONTROL | char_d |  | [emacs] |
# => | remove-keybindings | CONTROL | char_d |  | [vi_insert] |
# => | remove-keybindings | CONTROL | char_d |  | [vi_normal] |
# => | remove-keybindings | CONTROL | char_e |  | [emacs] |
# => | remove-keybindings | CONTROL | char_e |  | [vi_insert] |
# => | remove-keybindings | CONTROL | char_e |  | [vi_normal] |
# => | remove-keybindings | CONTROL | char_f |  | [emacs] |
# => | remove-keybindings | CONTROL | char_g |  | [emacs] |
# => | remove-keybindings | CONTROL | char_h |  | [emacs] |
# => | remove-keybindings | CONTROL | char_h |  | [vi_insert] |
# => | remove-keybindings | CONTROL | char_j |  | [emacs] |
# => | remove-keybindings | CONTROL | char_j |  | [vi_insert] |
# => | remove-keybindings | CONTROL | char_k |  | [emacs] |
# => | remove-keybindings | CONTROL | char_l |  | [emacs] |
# => | remove-keybindings | CONTROL | char_l |  | [vi_insert] |
# => | remove-keybindings | CONTROL | char_l |  | [vi_normal] |
# => | remove-keybindings | CONTROL | char_n |  | [emacs] |
# => | remove-keybindings | CONTROL | char_n |  | [vi_insert] |
# => | remove-keybindings | CONTROL | char_n |  | [vi_normal] |
# => | remove-keybindings | CONTROL | char_o |  | [emacs] |
# => | remove-keybindings | CONTROL | char_o |  | [vi_insert] |
# => | remove-keybindings | CONTROL | char_o |  | [vi_normal] |
# => | remove-keybindings | CONTROL | char_p |  | [emacs] |
# => | remove-keybindings | CONTROL | char_p |  | [vi_insert] |
# => | remove-keybindings | CONTROL | char_p |  | [vi_normal] |
# => | remove-keybindings | CONTROL | char_r |  | [emacs] |
# => | remove-keybindings | CONTROL | char_r |  | [vi_insert] |
# => | remove-keybindings | CONTROL | char_r |  | [vi_normal] |
# => | remove-keybindings | CONTROL | char_t |  | [emacs] |
# => | remove-keybindings | CONTROL | char_u |  | [emacs] |
# => | remove-keybindings | CONTROL | char_w |  | [emacs] |
# => | remove-keybindings | CONTROL | char_w |  | [vi_insert] |
# => | remove-keybindings | CONTROL | char_y |  | [emacs] |
# => | remove-keybindings | CONTROL | char_z |  | [emacs] |
# => | remove-keybindings | SHIFT | Down |  | [emacs] |
# => | remove-keybindings | SHIFT | Down |  | [vi_insert] |
# => | remove-keybindings | SHIFT | Down |  | [vi_normal] |
# => | remove-keybindings | SHIFT | End |  | [emacs] |
# => | remove-keybindings | SHIFT | End |  | [vi_insert] |
# => | remove-keybindings | SHIFT | End |  | [vi_normal] |
# => | remove-keybindings | SHIFT | Enter |  | [emacs] |
# => | remove-keybindings | SHIFT | Enter |  | [vi_insert] |
# => | remove-keybindings | SHIFT | Home |  | [emacs] |
# => | remove-keybindings | SHIFT | Home |  | [vi_insert] |
# => | remove-keybindings | SHIFT | Home |  | [vi_normal] |
# => | remove-keybindings | SHIFT | Left |  | [emacs] |
# => | remove-keybindings | SHIFT | Left |  | [vi_insert] |
# => | remove-keybindings | SHIFT | Left |  | [vi_normal] |
# => | remove-keybindings | SHIFT | Right |  | [emacs] |
# => | remove-keybindings | SHIFT | Right |  | [vi_insert] |
# => | remove-keybindings | SHIFT | Right |  | [vi_normal] |
# => | remove-keybindings | SHIFT | Up |  | [emacs] |
# => | remove-keybindings | SHIFT | Up |  | [vi_insert] |
# => | remove-keybindings | SHIFT | Up |  | [vi_normal] |
# => | remove-keybindings | SHIFT_ALT | char_, |  | [emacs] |
# => | remove-keybindings | SHIFT_ALT | char_, |  | [vi_insert] |
# => | remove-keybindings | SHIFT_ALT | char_, |  | [vi_normal] |
# => | remove-keybindings | SHIFT_ALT | char_. |  | [emacs] |
# => | remove-keybindings | SHIFT_ALT | char_. |  | [vi_insert] |
# => | remove-keybindings | SHIFT_ALT | char_. |  | [vi_normal] |
# => | remove-keybindings | SHIFT_CONTROL | End |  | [emacs] |
# => | remove-keybindings | SHIFT_CONTROL | End |  | [vi_insert] |
# => | remove-keybindings | SHIFT_CONTROL | End |  | [vi_normal] |
# => | remove-keybindings | SHIFT_CONTROL | Home |  | [emacs] |
# => | remove-keybindings | SHIFT_CONTROL | Home |  | [vi_insert] |
# => | remove-keybindings | SHIFT_CONTROL | Home |  | [vi_normal] |
# => | remove-keybindings | SHIFT_CONTROL | Left |  | [emacs] |
# => | remove-keybindings | SHIFT_CONTROL | Left |  | [vi_insert] |
# => | remove-keybindings | SHIFT_CONTROL | Left |  | [vi_normal] |
# => | remove-keybindings | SHIFT_CONTROL | Right |  | [emacs] |
# => | remove-keybindings | SHIFT_CONTROL | Right |  | [vi_insert] |
# => | remove-keybindings | SHIFT_CONTROL | Right |  | [vi_normal] |
# => | remove-keybindings | SHIFT_CONTROL | char_a |  | [emacs] |
# => | remove-keybindings | SHIFT_CONTROL | char_a |  | [vi_insert] |
# => | remove-keybindings | SHIFT_CONTROL | char_a |  | [vi_normal] |
# => | remove-keybindings | SHIFT_CONTROL | char_c |  | [emacs] |
# => | remove-keybindings | SHIFT_CONTROL | char_c |  | [vi_insert] |
# => | remove-keybindings | SHIFT_CONTROL | char_v |  | [emacs] |
# => | remove-keybindings | SHIFT_CONTROL | char_v |  | [vi_insert] |
# => | remove-keybindings | SHIFT_CONTROL | char_x |  | [emacs] |
# => | remove-keybindings | SHIFT_CONTROL | char_x |  | [vi_insert] |
# => | remove-keybindings | none | Backspace |  | [emacs] |
# => | remove-keybindings | none | Backspace |  | [vi_insert] |
# => | remove-keybindings | none | Backspace |  | [vi_normal] |
# => | remove-keybindings | none | Delete |  | [emacs] |
# => | remove-keybindings | none | Delete |  | [vi_insert] |
# => | remove-keybindings | none | Delete |  | [vi_normal] |
# => | remove-keybindings | none | Down |  | [emacs] |
# => | remove-keybindings | none | Down |  | [vi_insert] |
# => | remove-keybindings | none | Down |  | [vi_normal] |
# => | remove-keybindings | none | End |  | [emacs] |
# => | remove-keybindings | none | End |  | [vi_insert] |
# => | remove-keybindings | none | End |  | [vi_normal] |
# => | remove-keybindings | none | Enter |  | [emacs] |
# => | remove-keybindings | none | Esc |  | [emacs] |
# => | remove-keybindings | none | Esc |  | [vi_insert] |
# => | remove-keybindings | none | Esc |  | [vi_normal] |
# => | remove-keybindings | none | Home |  | [emacs] |
# => | remove-keybindings | none | Home |  | [vi_insert] |
# => | remove-keybindings | none | Home |  | [vi_normal] |
# => | remove-keybindings | none | Left |  | [emacs] |
# => | remove-keybindings | none | Left |  | [vi_insert] |
# => | remove-keybindings | none | Left |  | [vi_normal] |
# => | remove-keybindings | none | Right |  | [emacs] |
# => | remove-keybindings | none | Right |  | [vi_insert] |
# => | remove-keybindings | none | Right |  | [vi_normal] |
# => | remove-keybindings | none | Up |  | [emacs] |
# => | remove-keybindings | none | Up |  | [vi_insert] |
# => | remove-keybindings | none | Up |  | [vi_normal] |
# => | search-atuin-history | control | char_/ | {send: executehostcommand, cmd: } | [emacs, vi_normal, vi_insert] |
# => | yazi-menu | control | char_\\ | {send: executehostcommand, cmd:  y} | [emacs, vi_normal, vi_insert] |
```
