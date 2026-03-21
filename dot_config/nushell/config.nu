# config
$env.config.buffer_editor = $env.EDITOR
$env.config.table.missing_value_symbol = "[X]"
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
  } else if (false and $ctx.line =~ '^#\s*ai:.*\n') {
    const system_prompt = "# who are you

You are a Nushell command completion assistant.
You will receive a partial Nushell command and must complete it into a valid full command.

# return

Return only the completed command.
Do not include any explanation, markdown, or extra text.
Output exactly in this format: <output>COMPLETED_COMMAND</output>

Example:
Input: ls -
Output: <output>ls -la</output>
"
    let user_prompt = ($ctx.line | str replace --regex '^#\s*ai:' "")

    let full_prompt = [
      {
        role: "system"
        content: $system_prompt
      }
      {
        role: "system"
        content: $"<cwd>Current working directory: ($ctx.cwd)<cwd/>\n<environment_info>The user's current OS is: ($nu.os-info)</environment_info>"
      }
      {
        role: "user"
        content: $user_prompt
      }
    ]

    http post http://127.0.0.1:1357/v1/chat/completions --headers {'Authorization': 'Bearer abcd'} (
      {
        model: "gpt-5-mini"
        verbosity: "low"
        messages: $full_prompt
      } | to json
    ) | get choices | first | get message.content | parse '<output>{o}</output>' | get o
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

$env.LS_COLORS = (vivid generate molokai)
$env.VIRTUAL_ENV_DISABLE_PROMPT = true

$env.TRANSIENT_PROMPT_COMMAND = { starship module time }
$env.TRANSIENT_PROMPT_INDICATOR = { (starship module directory) + $"(ansi wd)$(ansi reset) " }

use ~\OneDrive\文件\git\nu_scripts\nu-hooks\nu-hooks\direnv\direnv.nu

source "~/.local/share/atuin/init.nu"

# user functions
overlay use ($nu.data-dir | path join user-fn.nu)

# hooks
overlay use ($nu.data-dir | path join hooks.nu)
overlay use ($nu.data-dir | path join hook_display_output.nu)

# keybindings
overlay use ($nu.data-dir | path join keybindings.nu)

# nupm
overlay use nupm/nupm/ --prefix
$env.NU_LIB_DIRS = $env.NU_LIB_DIRS ++ [($env.NUPM_HOME | path join modules)]
