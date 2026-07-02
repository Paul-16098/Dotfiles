# nu-lint-ignore-file: dynamic_script_import
# config
$env.config.buffer_editor = [(which --all $env.EDITOR | get 0.path) "--wait"]
$env.config.table.missing_value_symbol = "∅"
$env.config.display_errors.exit_code = true
$env.config.history.path = null
$env.config.history.file_format = "sqlite"
$env.config.history.sync_on_enter = false
$env.config.history.isolation = true
$env.config.color_config.string = {
  if $in =~ '^#[a-fA-F\d]{6}' {
    $in
  } else {
    'default'
  }
}
$env.config.show_banner = "short"
$env.config.rm.always_trash = true
$env.config.completions.quick = false
$env.config.footer_mode = "auto"
$env.config.filesize.precision = 2
$env.config.highlight_resolved_externals = true
$env.config.completions.partial = false
$env.config.error_lines = 3
$env.config.error_style = "nested"
$env.config.hinter.closure = {|ctx|
  if ($ctx.line | str length) == 0 {
    null
  } else {
    let candidate = (
      try {
        ^atuin search --cwd $ctx.cwd --limit 1 --search-mode prefix --cmd-only $ctx.line
        | lines
        | first
      } catch {
        null
      }
    )

    if $candidate == null or not ($candidate | str starts-with $ctx.line) {
      null
    } else {
      ($candidate | str substring (($ctx.line | str length))..)
    }
  }
}
$env.config.abbreviations = {
  ll: 'ls --long'

  py: python

  gl: 'git log'
  gp: 'git pull'
  gs: 'git status-or-show'
  gc: 'git clone'
}

$env.LS_COLORS = (vivid generate molokai)
$env.VIRTUAL_ENV_DISABLE_PROMPT = true

$env.TRANSIENT_PROMPT_COMMAND = { starship module time }
$env.TRANSIENT_PROMPT_INDICATOR = { (starship module directory) + $"(ansi wd)$(ansi reset) " }

source "~/.local/share/atuin/init.nu"

# user functions
overlay use ($nu.data-dir | path join user-fn.nu)

# hooks
overlay use ($nu.data-dir | path join hooks.nu)
overlay use ($nu.data-dir | path join hook_display_output.nu)

# keybindings
overlay use ($nu.data-dir | path join keybindings.nu)

# completions
overlay new completions
use ($nu.data-dir | path join user-completions.nu)

# nupm
# overlay use nupm/nupm/ --prefix
# $env.NU_LIB_DIRS = $env.NU_LIB_DIRS ++ [($env.NUPM_HOME | path join modules)]

# overlay new no-external
# # 避免意外呼叫外部指令
# def --wrapped run-external [--__call__: oneof<> ...args]: any -> any {
#   error make {
#     msg: "External commands are not allowed in this scope."
#     labels: [
#       {
#         text: "External command"
#         span: (metadata $__call__).span
#       }
#     ]
#     code: "nu::shell::external_command"
#     help: "Use External commands out of this scope or check your command."
#   }
# }
# overlay hide no-external

alias 'ast md' = from md
alias 'from md' = do { print --stderr 'Please use "ast md" instead.'; $in }

$env | reject --optional --ignore-case config FILE_PWD CURRENT_FILE PWD | transpose key val | str uppercase key | transpose --as-record --header-row | load-env
