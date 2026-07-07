---- 增強指令 ----
require("augment-command"):setup({
	open_file_after_creation = true,
	smooth_scrolling = true,
})
---- yatline ----
require("yatline"):setup({
	theme = require("yatline-catppuccin"):setup("macchiato"),

	section_separator = { open = "", close = "" },
	part_separator = { open = "", close = "" },
	inverse_separator = { open = "", close = "" },

	padding = { inner = 1, outer = 1 },

	permissions_t_fg = "green",
	permissions_r_fg = "yellow",
	permissions_w_fg = "red",
	permissions_x_fg = "cyan",
	permissions_s_fg = "white",

	tab_width = 20,

	selected = { icon = "󰻭", fg = "yellow" },
	copied = { icon = "", fg = "green" },
	cut = { icon = "", fg = "red" },

	files = { icon = "", fg = "blue" },
	filtereds = { icon = "", fg = "magenta" },

	total = { icon = "󰮍", fg = "yellow" },
	success = { icon = "", fg = "green" },
	failed = { icon = "", fg = "red" },

	show_background = true,

	display_header_line = true,
	display_status_line = true,

	component_positions = { "header", "tab", "status" },

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
				{ type = "string", name = "filter_query" }
			},
			section_b = {},
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
				-- { type = "coloreds", name = "created_time" }
			},
			section_c = {
				{ type = "string",   name = "hovered_path" },
				{ type = "coloreds", name = "symlink" },
				{ type = "coloreds", name = "count",       params = { true, true } },
			},
		},
		right = {
			section_a = {
				{ type = "coloreds", custom = false,          name = "task_states" },
				{ type = "string",   name = "cursor_position" },
			},
			section_b = {
				{ type = "string", name = "cursor_percentage" },
			},
			section_c = {
				{ type = "string",   name = "hovered_mime" },
				{ type = "coloreds", name = "permissions" },
			},
		},
	},
})
require("yatline-created-time"):setup()
function Yatline.coloreds.get:symlink()
	local symlink = {}
	local h = cx.active.current.hovered

	if not h then
		-- ya.dbg("no hovered")
		return nil
	end
	if not h.cha.is_link then
		-- ya.dbg("not a symlink")
		return nil
	end

	local link_target = h.link_to:strip_prefix(tostring(cx.active.current.cwd))
	if link_target == nil then
		-- ya.dbg("link target is nil")
		return nil
	end
	local link_target_str = ("symlink:.\\" .. tostring(link_target))
	table.insert(symlink, { link_target_str, th.mgr.cwd:fg() })
	return symlink
end

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
