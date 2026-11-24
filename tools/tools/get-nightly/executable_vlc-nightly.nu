use std/log

const SELF = path self
const ARTIFACTS_BASE_URL = "https://artifacts.videolan.org/vlc/nightly-win64-llvm/"

# Downloads the VLC nightly build for Windows
export def download-nightly [to: path, --force(-f)]: nothing -> int {
	log info $"Downloading VLC nightly build to ($to)..."

	let nig_path = http get $ARTIFACTS_BASE_URL | lines | parse r#'<td><a href="{url}">{date}/</a></td>'# | into datetime date --format '%Y%m%d-%H%M' | sort-by date | last | get url

	log info $"Resolved nightly path: ($nig_path)"

	# the auto sudo prompt makes this broken for now
	# if not ((input --numchar 1 --default y "Continue?") == y) {
	#   log info "Aborting download."
	#   return
	# }

	if not $force {
		if ("./vlc-nightly-ver" | path exists) {
			let old_ver = open "./vlc-nightly-ver" | str trim # nu-lint-ignore: catch_builtin_error_try
			log info $"Current installed version: ($old_ver)"
			if $old_ver == $nig_path {
				log info "Already up to date. No download needed."
				return 1
			}
		}
		log info $"New version available: ($nig_path)"
	}
	if (is-admin | not $in) {
		log info "Requesting administrative privileges..."
		return (sudo -E --inline $nu.current-exe $SELF --force=($force) --to=($to)) # nu-lint-ignore: unhandled_external_error
	} else {
		log info "Running with administrative privileges."
	}

	let nig_url = $ARTIFACTS_BASE_URL + $nig_path
	log info $"Resolved nightly URL: ($nig_url)"

	let ext = if $nu.os-info.name == "windows" { ".exe" }

	let nig_exe_path = http get $nig_url | lines | parse $'<td><a href="{url}">{name}($ext)</a></td>' | get 0
	log info $"Resolved nightly executable: ($nig_exe_path | get name)"

	let nig_exe_url = $nig_url + ($nig_exe_path | get url)
	log info $"Resolved nightly executable URL: ($nig_exe_url)"
	log info "Starting download..."

	let nig_sha_url = $nig_url + SHA512SUM

	http get $nig_exe_url | save --progress --force $to
	log info "Download complete."

	let exp_sha = http get $nig_sha_url | decode utf-8 | lines | where $it ends-with $ext | first | split column --number 2 ' ' sha file | get 0.sha

	let file_sha = open --raw $to | into binary | hash sha512

	if $exp_sha != $file_sha {
		log critical $"($to): ($file_sha) not eq ($exp_sha), check ($nig_sha_url) and ($to) and ($nig_exe_url)"
	} else {
		log info "check sha complete."
	}

	$nig_path | str trim | save --force "./vlc-nightly-ver"

	0
}

# Downloads the latest Nu binary for the current platform and installs it
export def main [--to: string, --force(-f)]: nothing -> nothing {
	let tmp_path = $to | default (mktemp --dry --suffix .exe)
	if (download-nightly $tmp_path --force=$force) == 0 {
		^$tmp_path
	}
	log info "Cleaned up temporary files."
	if ($tmp_path | path exists) {
		rm --recursive $tmp_path
	}
	log info done
}
