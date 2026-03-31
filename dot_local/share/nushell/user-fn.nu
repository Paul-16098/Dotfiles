use std/log

const self = path self

# Edit this config.
export def "config user-fn" []: nothing -> nothing {
  run-external $env.config.buffer_editor ($self)
}

# whois wrapper to format output as a table
export def --wrapped whois [
  ...rest: string # a rest that to whois-cli
]: nothing -> table {
  let process_output = (whois-cli --no-color ...$rest | complete)
  if $process_output.exit_code != 0 {
    error make {
      msg: $"whois command failed with exit code ($process_output.exit_code)"
      label: {
        span: (metadata $rest).span
        text: $process_output.stderr
      }
      help: "try whois-cli --help for more information"
    }
  }

  log debug "Processing whois output"
  let raw_output = $process_output.stdout
  log debug $"raw whois output=($raw_output)"

  if "No entries found for the selected source(s)." in $raw_output {
    return $"(ansi red)($raw_output)(ansi reset)"
  }

  let normalized_output = $raw_output | str replace --regex `(>>> ([.\s\S]*))` ""
  log debug $"new whois output=($normalized_output)"
  log debug "Parsing whois output into table"

  let parsed_lines = $normalized_output
    | lines
    | where (str contains :)
    | str trim
  log debug $"parsed lines=($parsed_lines)"

  let parsed_pairs = $parsed_lines
    | parse "{k}: {v}"
  log debug $"parsed key-value pairs=($parsed_pairs)"

  let grouped = $parsed_pairs
    | group-by k --prune
    | update cells {|value|
      if (($value | length) == 1) {
        $value | get 0.v
      } else {
        $value | par-each --keep-order { $in.v }
      }
    }

  mut status_code_urls = []
  for $item in ($grouped | get --optional --ignore-case "Domain Status") {
    let parts = $item | split row " "
    $status_code_urls ++= [[["status codes" url]; [($parts | get 0) ($parts | get 1)]]]
  }

  $grouped | merge {"Domain Status": $status_code_urls}
}

# es wrapper to always output json parsed table
export def --wrapped es [...rest: string]: nothing -> table {
  ^es "-instance" 1.5a ...$rest "--json"
}

export def app-update [] {
  use jobd.nu

  jobd spawn app-update-rustup {
    rustup self update
  }
  jobd spawn app-update-rust-toolchains {
    rustup update
  }
  jobd spawn app-update-airshipper {
    airshipper upgrade
    airshipper update
  }
  jobd spawn app-update-cargo-packages {
    cargo install-update --all --git
  }

  # job spawn --description app-update-coreutils-completions {
  #   const COREUTILS_COMPLETIONS_PATH = ($nu.user-autoload-dirs.0 | path join completions-coreutils.nu)
  #   "" | save --force $COREUTILS_COMPLETIONS_PATH
  #   ^coreutils --list | decode utf-8 | lines | par-each --keep-order {
  #     if ($in == '[') { return }
  #     let dis = (^coreutils --help $in | complete | get stdout | str replace --regex r#'\n\nUsage[\s\S]*$'# '' | lines | each { '# ' + $in } | str join "\n")
  #     $"($dis)\nexport extern \"coreutils ($in)\" [\n  --help \(-h) # get help information\n  --version \(-V) # get version information\n]\n" | save --append $COREUTILS_COMPLETIONS_PATH
  #   }
  # }

  job spawn --description app-update-atuin {
    $env.ATUIN_NOBIND = "true"
    atuin init --disable-up-arrow --disable-ctrl-r nu | save --force ("~/.local/share/atuin/init.nu" | path expand)
  }

  job spawn --description app-update-starship {
    starship init nu | save --force ($nu.user-autoload-dirs.0 | path join starship.nu)
  }

  job spawn --description app-update-carapace {
    carapace _carapace nushell | save --force ($nu.user-autoload-dirs.0 | path join carapace.nu)
  }

  jobd spawn app-update-yazi {
    cargo install --git https://github.com/sxyazi/yazi.git yazi-build
    ya pkg upgrade
  }

  job spawn --description app-update-nu {
    if (gh api repos/nushell/nushell/commits | from json | first | get sha) != (version | get commit_hash) {
      print --no-newline (char bel)
      print "A new version of NuShell is available, updateing:"
      start ~/.config/nushell/scripts/nu-selfupdate.ps1
    }
  }

  jobd wait

  print "All updates completed."
  print --no-newline (char bel)
  null
}

# highlight git log subject, reformat merge commit messages to include links to PRs and branches, also highlight common prefixes like feat:, fix:, etc. and version tags like v1.2.3
@category git
def git-log-subject-highlight [remote_url: string]: string -> string {
  # Merge pull request #ID from ...
  | str replace --regex '(?i)Merge pull request #(?<id>\d+) from (?<from>.+)' {|id from|
    $"[PR (ansi green_bold)($"($remote_url)/pull/($id)" | ansi link --text $'#($id)')(ansi reset) from (ansi green_bold)($from)(ansi reset)]"
  }
  # Merge branch 'branch' of ...
  | str replace --regex "(?i)Merge branch '(?<branch>.+)' of (?<from>.+)" {|branch from|
    $"[Merge branch '(ansi green_bold)($"($remote_url)/tree/($branch)" | ansi link --text $branch)(ansi reset)' of (ansi green_bold)($from | str replace --regex "^ssh\\.gitgud\\.io:" 'https://gitgud.io/' | ansi link --text $from)(ansi reset)]"
  }
  # Merge branch 'branch' into 'from'
  # Merge branch 'branch' into from
  | str replace --regex "(?i)Merge branch '(?<branch>.+)' into '?(?<from>[^']+)'?$" {|branch from|
    $"[Merge branch '(ansi green_bold)($"($remote_url)/tree/($branch)" | ansi link --text $branch)(ansi reset)' into '(ansi green_bold)($"($remote_url)/tree/($from)" | ansi link --text $from)(ansi reset)']"
  }
  # Merge commit 'cc62c8f4f6cb164756e97efb3a001fd73976a053' into tw-dev
  | str replace --regex "(?i)Merge commit '(?<commit>.+)' into '?(?<branch>[^']+)'?$" {|commit branch|
    $"[Merge commit '(ansi green_bold)($"($remote_url)/commit/($commit)" | ansi link --text $commit)(ansi reset)' into '(ansi green_bold)($"($remote_url)/tree/($branch)" | ansi link --text $branch)(ansi reset)']"
  }
  # feat:, fix:, docs:, style:, refactor:, perf:, test:, chore:
  | str replace --all --regex "(?i)^(feat|fix|docs|style|refactor|perf|test|chore|imp|revert|bump)(\\(.*\\))?(:|：)" $"(ansi green_bold)$1(ansi reset)(ansi green_bold)$2(ansi reset):"
  # Vx.x.x
  | str replace --all --regex "(?i)^(v[\\d\\.]+(-beta\\d+)?)" $"(ansi blue)$0(ansi reset)"
  | str replace --all --regex "#\\d+" $"(ansi green_bold)$0(ansi reset)"
}

# use in git log wrapper
const NOREPLY_EMAIL = ["@users.noreply.github.com" "@noreply.codeberg.org"]

# git log wrapper to format output as a table
# 
# noreply email is filtered out
# merge commit messages are reformatted to include links
# commit messages are highlighted for common prefixes
# version tags are highlighted
# no sort
@complete external
@category git
export def --wrapped "git log" [...rest: string]: nothing -> table {
  const SPLIT_STR = "»¦«"

  let remote_url = git-remote_url

  ^git log --pretty=$"%h($SPLIT_STR)%s($SPLIT_STR)%aN($SPLIT_STR)%aE($SPLIT_STR)%aD" ...$rest
  | lines
  | split column $SPLIT_STR commit subject name email date
  | into datetime date
  | update email {|row|
    let email = $row.email
    if ($NOREPLY_EMAIL | all {|suffix| not ($email | str ends-with $suffix) }) {
      $"mailto:($email)" | ansi link --text $email
    } else {
      $"(ansi dark_gray_italic)noreply email(ansi reset)"
    }
  } | default $"(ansi dark_gray_italic)N/A(ansi reset)" email
  | update subject { $in | str trim | git-log-subject-highlight $remote_url }
}

# get git remote url and convert to https if it's an ssh url, also remove .git suffix
@category git
def git-remote_url []: nothing -> string {
  git config get remote.origin.url | complete | get stdout | str trim | str replace "git@ssh.gitgud.io:" "https://gitgud.io/" | str replace --regex "\\.git$" ""
}

export alias gl = git log

export-env {
  # $env.NO_TUI_GIT_PULL to disable the wrapper for specific repos, useful for repos with very large number of commits to pull where counting commits can be slow, or repos with non-standard remote names where resolving upstream can be complicated
  # {
  #   REMOTE_URL: ["<github.com/><own/>repo"]
  #   FULL_COMMIT_SUBJECT: ["FULL SUBJECT"]}
  #   COMMIT_SUBJECT: ["SUBJECT"]
  # }
  $env.NO_TUI_GIT_PULL = $env.NO_TUI_GIT_PULL? | default {
      REMOTE_URL: []
      FULL_COMMIT_SUBJECT: []
      COMMIT_SUBJECT: []
    }
}

# git pull wrapper to show updated commits
@complete external
@category git
export def --wrapped "git pull" [...rest: string]: nothing -> nothing {
  use std/log

  let remote_url = git-remote_url
  if (
    $env.NO_TUI_GIT_PULL.REMOTE_URL
    | any {|el| $remote_url ends-with $el }
  ) {
    print --stderr $"Repository '(ansi green_bold)($remote_url)(ansi reset)' is configured to skip the interactive pull wrapper. Running git pull with provided arguments..."
    print (^git pull ...$rest)
    return
  }

  # Fetch first so remote-tracking refs are fresh before we compare HEADs.
  let fetch_out = (git fetch | complete)
  log debug $"git fetch output: ($fetch_out)"
  if $fetch_out.exit_code != 0 {
    error make --unspanned {
      msg: "git pull: Failed to fetch remote refs before pull"
      inner: [{msg: $fetch_out.stderr}]
    }
  }

  let head_info = (git rev-parse --verify HEAD | complete)
  log debug $"git rev-parse HEAD output: ($head_info)"
  if $head_info.exit_code != 0 {
    print --stderr $"There is no tracking information for the current branch.
Please specify which branch you want to merge with.
See git-pull\(1) for details.

    ('git pull <remote> <branch>' | nu-highlight)

If you wish to set tracking information for this branch you can do so with:

    ('git branch --set-upstream-to=<remote>/<branch> ' + (git branch --show-current) | nu-highlight)\n"

    return
  }

  let current_branch_info = (git branch --show-current | complete)
  log debug $"git branch --show-current output: ($current_branch_info)"
  let current_branch = if $current_branch_info.exit_code == 0 {
    $current_branch_info.stdout | str trim
  } else {
    ""
  }

  let upstream_info = (git rev-parse --abbrev-ref --symbolic-full-name "@{upstream}" | complete)
  log debug $"git rev-parse @{upstream} output: ($upstream_info)"
  # Prefer explicit upstream; fall back to origin/<branch> for repos without tracking config.
  let upstream_ref = if $upstream_info.exit_code == 0 {
    $upstream_info.stdout | str trim
  } else if ($current_branch | is-not-empty) {
    $"origin/($current_branch)"
  } else {
    "origin/HEAD"
  }

  let old_commit = ($head_info.stdout | str trim)
  log debug $"Current commit: ($old_commit), Upstream ref: ($upstream_ref)"
  let new_commit_info = (git rev-parse $upstream_ref | complete)
  log debug $"git rev-parse $upstream_ref output: ($new_commit_info)"
  if $new_commit_info.exit_code != 0 {
    print --stderr $"Could not resolve upstream ref '(ansi green_bold)($upstream_ref)(ansi reset)'."
    return
  }
  let new_commit = ($new_commit_info.stdout | str trim)
  log debug $"Upstream commit: ($new_commit)"

  if $old_commit == $new_commit {
    print --stderr ((ansi grey) + "Already up to date." + (ansi reset))
    return
  }

  # two-dot old..new means "reachable from new but not from old": commits to be pulled.
  let commits_to_pull = (git rev-list --count $"($old_commit)..($new_commit)")
  log debug $"Commits to pull from upstream: ($commits_to_pull)"
  if $commits_to_pull == "0" {
    # If upstream has no exclusive commits, local is ahead (or diverged without pullable commits).
    print --stderr $"Your branch is ahead of '(ansi green_bold)($upstream_ref)(ansi reset)' by (ansi green_bold)(git rev-list --count $"($new_commit)..($old_commit)")(ansi reset) commit\(s)."
    return
  }

  print --stderr $"Pulled latest changes. Showing commits from (ansi green_bold)($new_commit)(ansi reset) to (ansi green_bold)($old_commit)(ansi reset):"
  git log $"($old_commit)..($new_commit)" | let log | print --stderr $in

  if (
    $log.subject | ansi strip
    | all {|el| ($env.NO_TUI_GIT_PULL.FULL_COMMIT_SUBJECT | any {|sub| $el == $sub }) or ($env.NO_TUI_GIT_PULL.COMMIT_SUBJECT | any {|sub| $el =~ $sub }) }
  ) {
    print --stderr "The pull includes commits with subjects configured to skip the interactive pull wrapper.\nRunning git pull with provided arguments..."
    print (^git pull ...$rest)
    return
  }

  const KEY_HINT = $"(ansi green_underline)P(ansi reset_underline)ull(ansi reset), (ansi green_underline)S(ansi reset_underline)how(ansi reset), (ansi green_underline)L(ansi reset_underline)ogs(ansi reset) or (ansi green_underline)A(ansi reset_underline)bort(ansi reset)."
  print --stderr $KEY_HINT
  loop {
    match (input listen --types [key]) {
      {type: "key" key_type: "char" code: "p"} => {
        print --stderr "Pulling latest changes..."
        print --no-newline (^git pull --quiet ...$rest)
        print --stderr "Pull completed."
        break
      }
      {type: "key" key_type: "char" code: "s"} => {
        print --stderr "Showing changes..."
        try { git show $"($old_commit)..($new_commit)" } catch {
          if $in.exit_code == 141 { } else { error make "Not expected error" }
        }
        print --stderr $KEY_HINT
      }
      {type: "key" key_type: "char" code: "l"} => {
        print --stderr "Viewing logs..."
        print --stderr $log
        print --stderr $KEY_HINT
      }
      {type: "key" key_type: "char" code: "a"} => {
        print --stderr "Aborting pull."
        break
      }
    }
  }
}
export alias gp = git pull

export alias gc = git clone

def rust-debug-complete []: nothing -> record {
  {
    options: {
      case_sensitive: false
      sort: false
    }
    completions: [
      trace
      debug
      info
      warn
      error
      {
        value: off
        description: "Disable all logging"
      }
    ]
  }
}
# set rust debug env variables
export def --env rust-debug [lv: string@rust-debug-complete]: nothing -> nothing {
  load-env {
    RUST_LOG: $lv
    RUST_BACKTRACE: full
  }
}

def "nu-complete exe" []: nothing -> record {
  use complete-tools.nu complete-file
  complete-file exe
}

# check if input is a valid exe file
def is-exe [exe_file: path]: [
  nothing -> nothing
  nothing -> error
] {
  if not ($exe_file | str ends-with ".exe") {
    error make {
      msg: "Input file is not an .exe file"
      label: {
        text: "here"
        span: (metadata $exe_file).span
      }
      help: "please provide a valid .exe file"
    }
  }
  if not ($exe_file | path exists) {
    error make {
      msg: $"File not found: ($exe_file)"
      label: {
        text: "here"
        span: (metadata $exe_file).span
      }
      help: "please provide a valid .exe file path"
    }
  }
}

# get dll dependencies of an exe file
export def get-dll [
  exe_file: path@"nu-complete exe" # the exe file to analyze
]: nothing -> table<command: string, path?: path> {
  is-exe $exe_file
  let dll_dep = file $exe_file | get details.dependencies
  $dll_dep
  | par-each {|dll_name|
    let dll_find = which $dll_name --all;
    if ($dll_find | length) == 0 {
      let loc_dll_path = $exe_file | path dirname | path join $dll_name
      if ($loc_dll_path | path exists) {
        return {
          command: $dll_name
          path: $loc_dll_path
          type: $"(ansi d)local(ansi reset)"
        }
      }
      {
        command: (
          {
            scheme: https
            host: search.brave.com
            path: search
            params: {
              q: $dll_name
            }
          } | url join | ansi link --text $dll_name
        )
        type: "not found"
      }
    } else {
      $dll_find
      | upsert type {|table|
        if ($table | get path | str starts-with ($env.WINDIR | path expand)) {
          $"(ansi d)external(ansi reset):(ansi grey70)system(ansi reset)"
        } else {
          $"(ansi d)external(ansi reset):(ansi grey70)user(ansi reset)"
        }
      }
    }
  } | flatten
}

# kill process by name
export def "kill with name" [
  name: string # process name to kill
  --force (-f) # force kill the process
]: nothing -> nothing {
  ps | where name =~ $name | kill ...$in.pid --force=$force
}

# my custom pause function
export def pause []: nothing -> nothing {
  print "Press any key to continue..."
  input listen --types [key]
  null
}

def "nu-complete steamcmd" []: nothing -> record {
  {
    options: {
      sort: false
    }
    completions: [
      {
        value: '"+login"'
        description: 'Login to Steam: login <username> [<password>] [<Steam guard code>]'
      }
      {
        value: '"+login anonymous"'
        description: 'you may login anonymously using "login anonymous" if the content you
wish to download is available for anonymous access.'
      }
      {
        value: '+runscript'
        description: 'Executing a sequence of commands via a script file'
      }
      {
        value: 'workshop_download_item'
        description: 'download an item using the workshop system: workshop_download_item <appid> <PublishedFileId>'
      }

      {
        value: '+help'
        description: 'Displays help information about SteamCMD commands.'
      }
    ]
  }
}
# steamcmd wrapper to login
export def "steamcmd" [
  ...args: string@"nu-complete steamcmd" # +COMMAND [ARG]...
]: nothing -> nothing {
  /steamcmd/steamcmd.exe ...$args
}

# https://yazi-rs.github.io/docs/quick-start#shell-wrapper
export def --wrapped --env y [...args: string]: nothing -> nothing {
  if ("YAZI_LEVEL" in $env) {
    error make {
      msg: "You are already running yazi."
      labels: [
        # {
        #   text: "YAZI_LEVEL is set here"
        #   span: (metadata $env.YAZI_LEVEL).span
        # }
        {
          text: "call by here"
          span: (metadata $args).span
        }
      ]
    }
  }
  let tmp = (mktemp --tmpdir "yazi-cwd.XXXXXX")
  yazi ...$args --cwd-file $tmp
  let cwd = (open $tmp)
  if $cwd != $env.PWD and ($cwd | path exists) {
    cd $cwd
  }
  rm --force --permanent $tmp
}
# https://www.chezmoi.io/user-guide/frequently-asked-questions/design/#why-does-chezmoi-cd-spawn-a-shell-instead-of-just-changing-directory
export def --env "chezmoi cd" [] {
  cd (chezmoi source-path | path expand)
}
# used in keybindings.nu for F5
export def reload-config []: nothing -> string {
  [
    'let _pwd = pwd'
    'source ($nu.env-path)'
    'source ($nu.config-path)'

    '# load vendor autoloads'
    (
      $nu.vendor-autoload-dirs | par-each --keep-order {|dir|
        if ($dir | path exists) {
          ls ($dir | path expand) | where ($it.type == "file") and ($it.name ends-with ".nu")
          | par-each --keep-order {|path| $"source ($path.name)" }
        }
      }
    )
    '# load user autoloads'
    (
      $nu.user-autoload-dirs | par-each --keep-order {|dir|
        if ($dir | path exists) {
          ls ($dir | path expand) | where ($it.type == "file") and ($it.name ends-with ".nu")
          | par-each --keep-order {|path| $"source ($path.name)" }
        }
      }
    )

    'cd $_pwd'
    'unlet $_pwd'
  ] | flatten | flatten | str join "\n"
}
def "nu-complete image" []: nothing -> record {
  use complete-tools.nu complete-mime
  complete-mime image/*
}

# copy image to clipboard using powershell
export def "clip copy-image" [
  ...paths: path@"nu-complete image" # paths of images to copy to clipboard
]: nothing -> nothing {
  if ($nu.os-info.name != windows) {
    error make 'only windows is supported for copying images to clipboard'
  }

  let base = "Add-Type -AssemblyName System.Windows.Forms;"

  $paths | each {|path|
    let path = $path | path expand
    if not ($path | path exists) {
      error make {
        msg: $"File not found: (ansi green)($path)(ansi reset)"
        label: {
          text: "here"
          span: (metadata $path).span
        }
        help: "please provide a valid image file path"
      }
    }
    if ($path | path type) != file {
      error make {
        msg: $"Path is not a file: (ansi green)($path)(ansi reset)"
        label: {
          text: "here"
          span: (metadata $path).span
        }
        help: "please provide a valid image file path"
      }
    }
    if not (ls $path --mime-type | get 0.type | str starts-with "image/") {
      error make {
        msg: $"File is not an image: (ansi green)($path)(ansi reset)"
        label: {
          text: "here"
          span: (metadata $path).span
        }
        help: "please provide a valid image file path"
      }
    }
    if (ls $path --mime-type | get 0.type) == "image/gif" {
      error make {
        msg: $"GIF images are not supported: (ansi green)($path)(ansi reset)"
        label: {
          text: "here"
          span: (metadata $path).span
        }
        help: "please provide a non-GIF image file path"
      }
    }

    print --stderr $"Copying image to clipboard: (ansi green)($path)(ansi reset)"

    let app_comm = $"[Windows.Forms.Clipboard]::SetImage\($\([System.Drawing.Image]::Fromfile\('($path)')));"
    let comm = $base + $app_comm

    print --stderr $"> ($comm)"
    pwsh -Sta -Command $comm | complete | if ($in.exit_code != 0) {
      error make --unspanned {
        msg: $"Failed to copy image to clipboard: (ansi green)($path)(ansi reset)"
        inner: [{msg: $in.stderr}]
      }
    } else {
      print --stderr $"Successfully copied image to clipboard: (ansi green)($path)(ansi reset)"
    }
  }
  null
}

# get meme and copy to clipboard
export def "meme" [
  type: string@[fzf yazi nushell] = yazi # what tool to use to pick meme
]: nothing -> nothing {
  cd ~\OneDrive\文件\meme
  mut meme_path: list<string> = []
  match $type {
    yazi => {
      let chooser_file = mktemp --tmpdir "yazi-chooser_file.XXXXXX"
      yazi --chooser-file $chooser_file
      $meme_path = open $chooser_file | lines
      rm --force --permanent $chooser_file
    }
    fzf => {
      $meme_path = ^fzf --multi --ansi --preview '$env.TERM = "xterm-256color";viu --sixel -w $env.FZF_PREVIEW_COLUMNS -h $env.FZF_PREVIEW_LINES {}' | lines
    }

    nushell => {
      $meme_path = ls | input list --multi | get name
    }

    $_ => {
      error make {
        msg: $"Invalid meme type: (ansi green)($type)(ansi reset)"
        label: {
          text: "here"
          span: (metadata $type).span
        }
        help: "please provide a valid meme type"
      }
    }
  }

  clip copy-image ...$meme_path
}

# wrapper for docker compose commands to output json parsed tables
@complete external
export def --wrapped "docker compose ls" [...rest: string]: nothing -> table {
  ^docker compose ls --format json ...$rest | from json
}
# wrapper for docker compose ps to output json parsed table and format RunningFor column to human readable date
@complete external
export def --wrapped "docker compose ps" [...rest: string]: nothing -> table {
  ^docker compose ps --no-trunc --format json ...$rest | from json | update RunningFor {
    date from-human
  }
}
# wrapper for docker compose stats to output json parsed table, also add --no-trunc and --no-stream to get full output and only one snapshot
@complete external
export def --wrapped "docker compose stats" [...rest: string]: nothing -> table {
  ^docker compose stats --no-trunc --no-stream --format json ...$rest | from json
}
# wrapper for docker compose version to output json parsed record
@complete external
export def --wrapped "docker compose version" [...rest: string]: nothing -> record {
  ^docker compose version --format json ...$rest | from json
}
# wrapper for docker volumes to output json parsed table
@complete external
export def --wrapped "docker compose volumes" [...rest: string]: nothing -> table {
  ^docker compose volumes --format json ...$rest | from json
}

# use $color_code to highlight text in output
@example "highlight with text" { "abc" | highlight "a" } --result "\u{1b}[1;31ma\u{1b}[0mbc"
@example "highlight with 2 text" { "abc" | highlight "a" "c" } --result "\u{1b}[1;31ma\u{1b}[0mb\u{1b}[1;31mc\u{1b}[0m"
@example "highlight with regex" { "abc" | highlight --regex "^a.*$" } --result "\u{1b}[1;31mabc\u{1b}[0m"
export def highlight [
  --color-code (-c) = "red_bold" # use in ansi $color_code to highlight text, hex string or color name supported
  --regex (-r) # if set, treat highlight_text as regex pattern, otherwise treat it as plain text, default is false
  ...highlight_text: string # text to highlight in output, can not include regex special characters
]: string -> string {
  let highlight_regex = ($highlight_text | if not $regex { str escape-regex } else { $in } | str join '|')
  $in | str replace --all --regex $"\(($highlight_regex)\)" $"(ansi $color_code)$1(ansi reset)"
}
# alternative buffer wrapper, use callback to run commands in alternative buffer and get the output, the callback should return the output as a string, the alternative buffer will be cleared after the callback is executed
# nu-lint-ignore: missing_in_type, missing_output_type
export def --env alternative-buffer [
  callback: closure # a callback to run commands in alternative buffer, the callback should return the output as a string

  --keep-env # Keep the environment defined inside the command.

  # nu-lint-ignore: add_type_hints_arguments
  ...rest: any # a rest to pass to the callback
]: any -> any {
  print --no-newline (ansi --escape ?1049h)

  $in | do --env=$keep_env $callback ...$rest | let out

  print --no-newline (ansi --escape ?1049l)

  $out
}

export def --wrapped 'vt scan file' [path: path ...rest]: any -> any {
  ^vt scan file $path ...$rest --silent --wait | from yaml
}

# a wrapper for atuin history command to output a table with date, duration, exit code and command, also parse the duration to a duration type and exit code to int, also highlight the command using nu-highlight
export def '_atuin history' [--limit: int = 500 --reverse] {
  atuin search --reverse=$reverse --limit 500 | parse "{date}\t{duration}\t{exit_with}\t{command}" | into datetime date | into int exit_with | update command { nu-highlight } | update duration {
    match $in {
      $_ if $_ ends-with "ms" => { str replace --regex 'ms$' '' | into duration --unit ms }
      $_ if $_ ends-with "s" => { str replace --regex 's$' '' | into duration --unit sec }
      $_ if $_ ends-with "m" => { str replace --regex 'm$' '' | into duration --unit min }
      _ => {
        error make {
          msg: $"Unknown duration format: (ansi green)($in)(ansi reset)"
          label: {
            text: "here"
            span: (metadata $in).span
          }
          help: "please provide a valid duration format, e.g. 100ms, 2s"
        }
      }
    }
  }
}
# export def '_atuin_search_cmd' [...rest] {
#   let s = _atuin history | input list --fuzzy --display {|| $"($in.duration)\t($in.command)" }
#   if ($s | is-not-empty) {
#     print $s
#     commandline edit ($s.command | ansi strip)
#   }
# }
