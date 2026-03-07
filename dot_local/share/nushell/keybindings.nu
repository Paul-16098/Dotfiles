const self = path self

# Edit this config.
export def "config user-keybindings" []: nothing -> nothing {
  run-external $env.config.buffer_editor ($self)
}
# https://www.nushell.sh/book/line_editor.html#keybindings:~:text=%24config.keybindings-,modifier,-%3A%20A%20key%20modifier
const MODIFIER = [none control alt shift shift_alt alt_shift control_alt alt_control control_shift shift_control control_alt_shift control_shift_alt]
const MODE = [emacs vi_normal vi_insert]

export def add-keybindings [
  --mode (-m) = [emacs vi_normal vi_insert]
  --name (-n) = "custom-keybinding"
  modifier: string@$MODIFIER
  keycode: string
  event: oneof<record>
]: nothing -> record<name: string, modifier: string, keycode: string, mode: list<string>, event: oneof<record>> {
  {
    name: $name
    modifier: $modifier
    keycode: $keycode
    mode: $mode
    event: $event
  }
}
export def remove-keybindings [modifier: string@$MODIFIER keycode: string ...mode: string@$MODE]: nothing -> record<name: string, modifier: string, keycode: string, mode: list<string>, event: nothing> {
  {
    name: "remove-keybindings"
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
  $env.config.keybindings = [
    # remove default keybinding
    ...(remove-default-keybindings { true })
    # add default keybinding
    ## none
    (add-keybindings --name "add-default-keybinding" none Backspace {edit: Backspace})
    (add-keybindings --name "add-default-keybinding" none Delete {edit: Delete})
    (
      add-keybindings --name "add-default-keybinding" none Down {
        until: [{send: MenuDown} {send: Down}]
      }
    )
    (
      add-keybindings --name "add-default-keybinding" none Up {
        until: [{send: MenuUp} {send: Up}]
      }
    )
    (add-keybindings --name "add-default-keybinding" none Left {until: [{send: MenuLeft} {send: Left}]})
    (add-keybindings --name "add-default-keybinding" none Right {until: [{send: HistoryHintComplete} {send: MenuRight} {send: Right}]})
    (add-keybindings --name "add-default-keybinding" none Enter {send: Enter})
    (add-keybindings --name "add-default-keybinding" none Esc {send: Esc})
    (add-keybindings --name "add-default-keybinding" none Home {edit: MoveToLineStart})
    (add-keybindings --name "add-default-keybinding" none End {edit: MoveToLineEnd})
    ## CONTROL
    (add-keybindings --name "add-default-keybinding" CONTROL Backspace {edit: BackspaceWord})
    (add-keybindings --name "add-default-keybinding" CONTROL Delete {edit: DeleteWord})
    (add-keybindings --name "add-default-keybinding" CONTROL Left {edit: MoveWordLeft})
    (
      add-keybindings --name "add-default-keybinding" CONTROL Right {
        until: [{send: HistoryHintWordComplete} {edit: MoveWordRight}]
      }
    )
    (add-keybindings --name "add-default-keybinding" CONTROL char_c {send: CtrlC})
    (add-keybindings --name "add-default-keybinding" CONTROL char_d {send: CtrlD})
    (add-keybindings --name "add-default-keybinding" CONTROL char_z {edit: Undo})
    ## SHIFT_CONTROL
    (add-keybindings --name "add-default-keybinding" CONTROL_SHIFT char_a {edit: SelectAll})
    (add-keybindings --name "add-default-keybinding" CONTROL_SHIFT char_c {edit: CopySelectionSystem})
    (add-keybindings --name "add-default-keybinding" CONTROL_SHIFT char_v {edit: PasteSystem})
    (add-keybindings --name "add-default-keybinding" CONTROL_SHIFT char_x {edit: CutSelectionSystem})
    (add-keybindings --name "add-default-keybinding" CONTROL_SHIFT Left {edit: MoveWordLeft select: true})
    (add-keybindings --name "add-default-keybinding" CONTROL_SHIFT Right {edit: MoveWordRight select: true})
    ## SHIFT
    (add-keybindings --name "add-default-keybinding" SHIFT Enter {edit: InsertNewline})
    (add-keybindings --name "add-default-keybinding" SHIFT Left {edit: MoveLeft select: true})
    (add-keybindings --name "add-default-keybinding" SHIFT Right {edit: MoveRight select: true})
    # add custom keybindings
    (add-keybindings control_shift char_z {edit: Redo})
    {
      name: reload_config
      modifier: none
      keycode: f5
      mode: [emacs vi_insert vi_normal]
      event: [
        {
          send: executehostcommand
          cmd: (reload-config)
        }
      ]
    }
    {
      name: atuin
      modifier: control
      keycode: "char_/"
      mode: [emacs vi_normal vi_insert]
      event: {send: executehostcommand cmd: (_atuin_search_cmd)}
    }
    {
      # why custom?
      # default ctrl+d is send CtrlD event, if commandline not null, it will del cursor word, but I want it always send "exit 0" command to host
      name: "exit-nu"
      modifier: control
      keycode: char_d
      mode: [emacs vi_normal vi_insert]
      event: {send: executehostcommand cmd: "exit"}
    }
    {
      name: "cls-nu"
      modifier: control
      keycode: char_l
      mode: [emacs vi_normal vi_insert]
      event: {send: ClearScreen}
    }
    {
      name: "cls-nu-no-keep-scrollback"
      modifier: control_shift
      keycode: char_l
      mode: [emacs vi_normal vi_insert]
      event: {send: ClearScrollBack}
    }
    {
      name: "overlay-menu"
      modifier: control
      keycode: "char_\\"
      mode: [emacs vi_normal vi_insert]
      event: [
        # {
        #   edit: InsertString
        #   value: "overlay "
        # }
        # {send: Menu name: overlay_menu}
        {send: executehostcommand cmd: "y"}
      ]
    }
  ]
}
