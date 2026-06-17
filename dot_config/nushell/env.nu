# env

$env.NU_PLUGIN_DIRS = $env.NU_PLUGIN_DIRS ++ ["~/.cargo/bin/"]
$env.NU_LIB_DIRS = $env.NU_LIB_DIRS ++ [`~\.local\share\nushell`]

open ($nu.config-path | path dirname | path join env.nuom) | from nuon | load-env

chcp 65001 | ignore

use std/formats *
use std-rfc/conversions 'into list'
