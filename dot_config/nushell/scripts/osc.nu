# notify use osc777
export def osc777 [title: string body: string] {
  print --no-newline --stderr $"(ansi --osc '777');notify;($title);($body)\a"
}
