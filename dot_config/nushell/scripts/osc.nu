# notify use osc777
export def osc777 [title: string body: string] {
  print --no-newline --stderr $"(ansi --osc '777');notify;($title);($body)\a"
}
# Kitty Keyboard Protocol
export def kitty-keyboard-protocol []: nothing -> binary {
  term query (ansi --escape '?u') --prefix $"(ansi csi)?" --terminator u
}
