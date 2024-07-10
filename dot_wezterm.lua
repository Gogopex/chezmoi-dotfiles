local wezterm = require("wezterm")

local config = wezterm.config_builder()
local act = wezterm.action

config.font = wezterm.font("BerkeleyMono Nerd Font")
config.font_size = 14.0
config.color_scheme = "Gruvbox Dark (Gogh)"
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.integrated_title_button_style = "MacOsNative"
config.enable_scroll_bar = true
config.default_prog = { "/opt/homebrew/Cellar/fish/3.7.1/bin/fish", "-l" }
config.leader = { key = "a", mods = "CTRL|OPT|CMD|SHIFT" }

wezterm.on("update-right-status", function(window, pane)
	window:set_right_status(window:active_workspace())
end)

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
	-- this is set by the plugin, and unset on ExitPre in Neovim
	return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "META" or "CTRL",
		action = wezterm.action_callback(function(win, pane)
			if is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "META" or "CTRL" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

config.keys = {
	-- split panes
	{
		key = "d",
		mods = "CMD",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "d",
		mods = "CMD|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	-- utilities
	{
		key = "p",
		mods = "CMD",
		action = wezterm.action.ActivateCommandPalette,
	},
	{
		mods = "CMD|SHIFT",
		key = "Enter",
		action = wezterm.action.ActivateCopyMode,
	},
	{ key = "h", mods = "CMD", action = act.ActivateTabRelative(-1) },
	{ key = "l", mods = "CMD", action = act.ActivateTabRelative(1) },
	--{ key = "LeftArrow", mods = "CMD|SHIFT", action = act.ActivateWindowRelative(-1) },
	--{ key = "RightArrow", mods = "CMD|SHIFT", action = act.ActivateWindowRelative(1) },
	{
		key = "N",
		mods = "CTRL|SHIFT",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- `line` will be `nil` if user hits <ESC> without entering anything.
				-- If enter is pressed, line will be the text they wrote; otherwise "".
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
	{
		key = "g",
		mods = "CTRL",
		action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},
	-- workspace stuff
	{ key = "p", mods = "CMD", action = act.SwitchWorkspaceRelative(1) },
	{ key = "o", mods = "CMD", action = act.SwitchWorkspaceRelative(-1) },
	-- panes stuff
	{
		key = "Z",
		mods = "CTRL",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "h",
		mods = "CTRL",
		action = act.ActivatePaneDirection("Left"),
	},
	--{
	--	key = "l",
	--	mods = "CTRL",
	--	action = act.ActivatePaneDirection("Right"),
	--},
	--{
	--	key = "k",
	--		mods = "CTRL",
	--	action = act.ActivatePaneDirection("Up"),
	--},
	--	{
	--		key = "j",
	--		mods = "CTRL",
	--		action = act.ActivatePaneDirection("Down"),
	--	},
	{
		mods = "LEADER",
		key = "m",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "o",
		mods = "CTRL|OPT",
		action = act.PaneSelect,
	},
	-- move between split panes
	split_nav("move", "h"),
	split_nav("move", "j"),
	split_nav("move", "k"),
	split_nav("move", "l"),
	-- resize panes
	split_nav("resize", "h"),
	split_nav("resize", "j"),
	split_nav("resize", "k"),
	split_nav("resize", "l"),
}
-- config.default_prog = { "/Users/ludovicpouey/.cargo/bin/zellij" }

return config
