run ./apply-patch.nu | table | print --stderr $in

with-env {HELIX_DISABLE_AUTO_GRAMMAR_BUILD: 1} {
  cargo install --profile opt --config 'build.rustflags=["-C", "target-cpu=native"]' --path helix-term --locked
}
