local wezterm = require("wezterm")
local Config = {}

local opacity = 0.75
local transparent_bg = "rgba(22, 24, 26, " .. opacity .. ")"

local colors = require("config.colors")

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    -- Configs for Windows only
    -- font_dirs = {
    --     'C:\\Users\\whoami\\.dotfiles\\.fonts'
    -- }
    -- Config.default_prog = { "pwsh", "-NoLogo" }
    Config.default_prog = { "pwsh", "-NoLogo", "-ExecutionPolicy", "RemoteSigned", "-NoProfileLoadTime" }
elseif wezterm.target_triple == 'x86_65-unknown-linux-gnu' then
    -- Configs for Linux only
    -- font_dirs    = { '$HOME/.dotfiles/.fonts' }
end

-- Font
Config.font = wezterm.font_with_fallback({
    {
        family = "SauceCodePro Nerd Font Mono",
        weight = "Medium",
    },
    "Segoe UI Emoji",
})
Config.font_size = 9
Config.allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace"

-- Window
Config.adjust_window_size_when_changing_font_size = false
Config.audible_bell = "Disabled"
Config.initial_rows = 45
Config.initial_cols = 180
-- Config.window_decorations = "RESIZE"
Config.window_close_confirmation = "AlwaysPrompt"
Config.win32_system_backdrop = "Acrylic"
Config.max_fps = 60
Config.animation_fps = 60
Config.cursor_blink_rate = 250
Config.scrollback_lines = 10000
Config.default_workspace = "main"

-- Colors
Config.colors = colors
Config.force_reverse_video_cursor = true

-- Tabs
Config.enable_tab_bar = true
Config.hide_tab_bar_if_only_one_tab = false
Config.show_tab_index_in_tab_bar = false
Config.use_fancy_tab_bar = false
Config.tab_bar_at_bottom = true
Config.colors.tab_bar = {
   background = transparent_bg,
   new_tab = { fg_color = colors.foreground, bg_color = colors.background },
   new_tab_hover = { fg_color = colors.background, bg_color = colors.foreground },
}

-- Dim inactive panes
Config.inactive_pane_hsb = {
    saturation = 0.24,
    brightness = 0.5
}

require("config.keybinds").setup(Config)
require("config.statusbar").setup(colors)
require("config.ssh").setup(Config)

return Config
