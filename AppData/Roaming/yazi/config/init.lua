---- 增強指令 ----
require("augment-command"):setup({
	open_file_after_creation = true,
	smooth_scrolling = true,
})
---- yatline ----
require("yatline"):setup({
	theme = require("yatline-catppuccin"):setup("macchiato"),

	total = { icon = "󰮍", fg = "yellow" },
	success = { icon = "", fg = "green" },
	failed = { icon = "", fg = "red" },

	header_line = {
		left = {
			section_a = {
				{ type = "line", name = "tabs" },
			},
			section_b = {
			},
			section_c = {},
		},
		right = {
			section_a = {
				{ type = "coloreds", custom = false,            name = "count",      params = { true, false } },
				{ type = "coloreds", custom = false,            name = "task_states" },
				{ type = "string",   name = "cursor_position" },
				{ type = "string",   name = "cursor_percentage" },
			},
			section_b = {
				{ type = "string", name = "filter_query" },
			},
			section_c = {},
		},
	},

	status_line = {
		left = {
			section_a = {
				{ type = "string", name = "tab_mode" },
			},
			section_b = {
				{ type = "string", name = "hovered_size" },
			},
			section_c = {
				{ type = "string",   name = "hovered_path" },
				{ type = "coloreds", custom = false,       name = "symlink" },
			},
		},
		right = {
			section_a = {
			},
			section_b = {
			},
			section_c = {
				{ type = "string",   name = "hovered_mime" },
				{ type = "coloreds", name = "permissions" },
			},
		},
	},
})
require("yatline-symlink"):setup()

--- fg ---
require("fg"):setup({
})
--- mime-ext ---
require("mime-ext.local"):setup {
	-- 展開現有的檔案名稱資料庫（小寫），例如：
	with_files = {
	},

	-- 擴展現有的擴充資料庫（小寫），例如：
	with_exts = {
	},

	-- 如果 MIME 類型不在檔案名稱和副檔名資料庫中，則回退到 Yazi 預設的 `mime.local` 插件，該插件使用 `file(1)`
	fallback_file1 = true,
}
--- font-sample ---
require('font-sample'):setup {
	text = 'ABCDEF abcdef\n0123456789 \noO08 iIlL1 g9qCGQ\n8%& <([{}])>\n.,;: @#$-_="\n== <= >= != ffi\nâéùïøçÃĒÆœ\n및개요これ直楽糸',
	canvas_size = '750x800',
	font_size = 80,
	-- https://imagemagick.org/script/color.php
	bg = 'white',
	fg = 'black',
}
--- sopt ---
require('spot'):setup {
	metadata_section = {
		enable = true,
		hash_cmd = 'md5sum',      -- 其他哈希命令可能會更慢
		hash_filesize_limit = 150, -- 以 MB 為單位，設定 0 表示停用
		relative_time = true,     -- 2026-01-01 或 n 天前
		time_format = '%Y-%m-%d %H:%M', -- https://www.man7.org/linux/manpages/man3/strftime.3.html
		show_compression = true, ---@type boolean
	},
	plugins_section = {
		enable = true,
	},
	style = {
		section = 'green',
		key = 'reset',
		value = 'blue',
		colorize_metadata = false,
		height = 20,
		width = 60,
		key_length = 15,
	},
}
--- git ---
require("git"):setup()
--- sync_yanked ---
require("session"):setup {
	sync_yanked = true,
}
--- bookmark ---
require("whoosh"):setup {
	keys = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ~/"
}
