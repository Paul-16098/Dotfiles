-- 引入 wezterm API
---@type Wezterm
local wezterm = require('wezterm')

-- 這將保存配置。
---@type Config
local config = wezterm.config_builder()

-- 這是您實際應用配置選擇的地方。
config.exit_behavior_messaging = 'Terse'
config.font = wezterm.font_with_fallback {
	{ family = 'FiraCode Nerd Font Mono', harfbuzz_features = { 'calt', 'liga' } },
	'YouYuan'
}

config.disable_default_key_bindings = true
config.keys = {
	{ key = 'L', mods = 'CTRL', action = wezterm.action.ShowDebugOverlay },
	{
		key = 'w',
		mods = 'CTRL',
		action = wezterm.action.CloseCurrentPane { confirm = true },
	},
	{
		key = 'P',
		mods = 'CTRL',
		action = wezterm.action.ActivateCommandPalette,
	},
	{
		key = "t",
		mods = "CTRL",
		action = wezterm.action.SpawnTab "CurrentPaneDomain"
	},
	{
		key = 'T',
		mods = 'CTRL',
		action = wezterm.action.ShowLauncher,
	}
}

config.default_prog = { 'nu' }
config.launch_menu = {
	{
		label = 'Nushell',
		args = { 'nu' },
	}
}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
	local function file_exists(path)
		local file = io.open(path, 'r')
		if file then
			file:close()
			return true
		end
		return false
	end

	local add_if_exists = {
		{
			label = 'PowerShell',
			args = { 'powershell.exe', '-NoLogo' },
		},
		{
			label = 'PowerShell 7',
			args = { 'pwsh.exe', '-NoLogo' },
		},
		{
			label = 'Git Bash',
			args = { "C:/Program Files/Git/bin/bash.exe", "-i", "-l" }
		},
		{
			label = 'Command Prompt',
			args = { 'cmd.exe' },
		},
		{
			label = 'Node.js',
			args = { 'C:\\Program Files\\nodejs\\node.exe' }
		},
		{
			label = 'yazi',
			args = { 'C:\\Users\\pl816\\.cargo\\bin\\yazi.exe' }
		}
	}

	for _, v in ipairs(add_if_exists) do
		if file_exists(v.args[1]) then
			table.insert(config.launch_menu, v)
		end
	end
end

config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'

-- 最後，將配置傳回wezterm：
return config
