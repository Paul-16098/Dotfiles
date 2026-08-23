const self = path self

# Edit this config.
export def "config user-keybindings" []: nothing -> nothing {
  run-external $env.config.buffer_editor ($self)
}
# https://www.nushell.sh/book/line_editor.html#keybindings:~:text=%24config.keybindings-,modifier,-%3A%20A%20key%20modifier
const MODIFIER = [none control alt shift shift_alt alt_shift control_alt alt_control control_shift shift_control control_alt_shift control_shift_alt]
const MODE = [emacs vi_normal vi_insert]

export def add-keybindings [
  --mode (-m): list<string> = [emacs vi_normal vi_insert]
  --name (-n): string
  modifier: string@$MODIFIER
  keycode: string
  event: oneof<record, list<record>>
]: nothing -> record<name: oneof<string, nothing>, modifier: string, keycode: string, mode: list<string>, event: oneof<record, list<record>>> {
  {
    name: $name
    modifier: $modifier
    keycode: $keycode
    mode: $mode
    event: $event
  }
}

export def remove-keybindings [
  modifier: string@$MODIFIER
  keycode: string
  mode: list<string> = $MODE
  --name (-n): string
]: nothing -> record<name: oneof<string, nothing>, modifier: string, keycode: string, mode: list<string>, event: nothing> {
  {
    name: $name
    modifier: $modifier
    keycode: $keycode
    mode: $mode
    event: null
  }
}
# just modifier and keycode are support
export def default-keybindings-to-config [wh_condition: closure]: nothing -> table<mode: string, modifier: string, code: string, event: string> {
  keybindings default | where $wh_condition
  | update modifier {
    parse "KeyModifiers({modifier})" | get 0.modifier | if $in == "0x0" { "none" } else { $in }
    | if ($in | str contains "|") {
      $in | str replace " | " "_"
    } else {
      $in
    }
  }
  | update code {
    if ($in | str contains "Char(") {
      "char_" + ($in | parse "Char('{keycode}')" | get 0.keycode)
    } else {
      $in
    }
  }
}
export def remove-default-keybindings [wh_condition: closure]: nothing -> table<name: string, modifier: string, keycode: string, mode: list<string>, event: nothing> {
  default-keybindings-to-config $wh_condition | par-each {|kb|
    remove-keybindings $kb.modifier $kb.code $kb.mode
  }
}

export-env {
  # remove default keybinding
  $env.config.keybindings = []
  # add custom keybinding
  $env.config.keybindings = [
    ## none
    (
      add-keybindings none tab {
        until: [
          {send: menu name: completion_menu}
          {send: menunext}
          {edit: 'complete'}
        ]
      }
    )
    (add-keybindings none Backspace {edit: Backspace})
    (add-keybindings none Delete {edit: Delete})
    (
      add-keybindings none Down {
        until: [{send: MenuDown} {send: executehostcommand cmd: " commandline edit --replace ''"}]
      }
    )
    (
      add-keybindings none Up {
        until: [{send: MenuUp} {send: executehostcommand cmd: (_atuin_search_cmd '--shell-up-key-binding')}]
      }
    )
    (add-keybindings none Left {until: [{send: MenuLeft} {send: Left}]})
    (add-keybindings none Right {until: [{send: HistoryHintComplete} {send: MenuRight} {send: Right}]})
    (add-keybindings none Enter {send: Enter})
    (add-keybindings none Esc {send: Esc})
    (add-keybindings none Home {edit: MoveToLineStart})
    (add-keybindings none End {edit: MoveToLineEnd})

    ## CONTROL
    (add-keybindings CONTROL Backspace {edit: BackspaceWord})
    (add-keybindings CONTROL Delete {edit: DeleteWord})
    (add-keybindings CONTROL Left {edit: MoveWordLeft})
    (
      add-keybindings CONTROL Right {
        until: [{send: HistoryHintWordComplete} {edit: MoveWordRight}]
      }
    )
    (add-keybindings CONTROL char_z {edit: Undo})
    (add-keybindings CONTROL char_o {send: OpenEditor})
    ## SHIFT_CONTROL
    (add-keybindings CONTROL_SHIFT Left {edit: MoveWordLeft select: true})
    (add-keybindings CONTROL_SHIFT Right {edit: MoveWordRight select: true})
    ## SHIFT
    (add-keybindings SHIFT Enter {edit: InsertNewline})
    (add-keybindings SHIFT Left {edit: MoveLeft select: true})
    (add-keybindings SHIFT Right {edit: MoveRight select: true})
    (add-keybindings SHIFT Up {edit: MoveLineUp select: true})
    (add-keybindings SHIFT Down {edit: MoveLineDown select: true})
    # add custom keybindings
    (add-keybindings CONTROL char_a {edit: SelectAll})
    (add-keybindings CONTROL char_c {until: [{edit: CopySelectionSystem} {send: CtrlC}]})
    (add-keybindings CONTROL char_v {edit: PasteSystem})
    (add-keybindings CONTROL char_x {edit: CutSelectionSystem})

    (add-keybindings CONTROL Up {edit: MoveLineUp})
    (add-keybindings CONTROL Down {edit: MoveLineDown})

    (add-keybindings control_shift char_z {edit: Redo})

    (add-keybindings --name "reload-config" none f5 {send: executehostcommand cmd: (reload-config)})

    (add-keybindings --name "search-atuin-history" control "char_/" {send: executehostcommand cmd: (_atuin_search_cmd)})

    # why custom?
    # default ctrl+d is send CtrlD event, if commandline not null, it will del cursor word, but I want it always send "exit 0" command to host
    (add-keybindings --name "exit-nu" control char_d {send: executehostcommand cmd: " exit 0"})

    (add-keybindings --name "clear-screen" control char_l {send: ClearScreen})
    (add-keybindings --name "clear-scrollback" control_shift char_l {send: ClearScrollBack})
    (add-keybindings --name "yazi-menu" control "char_\\" {send: executehostcommand cmd: " y"})
    (add-keybindings --name help control char_h {send: executehostcommand cmd: " print '';help $'(commandline|str trim)'"})
  ]
}
