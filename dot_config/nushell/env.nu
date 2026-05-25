# env

const NU_PLUGIN_DIRS = $NU_PLUGIN_DIRS ++ ["~/.cargo/bin/"]

load-env {
  PATH: ($env.PATH | path expand | uniq)
}
open ($nu.config-path | path dirname | path join env.nuom) | from nuon | load-env

chcp 65001 | ignore

use std/formats *
use std-rfc/conversions 'into list'
