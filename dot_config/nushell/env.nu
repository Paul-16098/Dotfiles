# env

$env.NU_PLUGIN_DIRS = $env.NU_PLUGIN_DIRS ++ ["~/.cargo/bin/"] | path expand | uniq
$env.NU_LIB_DIRS = $env.NU_LIB_DIRS ++ [`~\.local\share\nushell`] | path expand | uniq

open ($nu.config-path | path dirname | path join env.nuon) | load-env

chcp 65001 | ignore

use std/formats *
use std-rfc/conversions 'into list'
