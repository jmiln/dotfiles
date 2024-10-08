local wezterm = require('wezterm')
local utils = require("config.utils")

-- Wezterm has a built-in nerd fonts
-- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
local nf = wezterm.nerdfonts

local M = {}

local getProcessName = function(s)
    local a = string.gsub(s, '(.*[/\\])(.*)', '%2')
    return a:gsub('%.exe$', '')
end


M.setup = function(colors)
    local modes = {
        search_mode = { i = "󰍉", txt = "SEARCH", bg = colors.brights[4], pad = 10 },
        window_mode = { i = "󱂬", txt = "WINDOW", bg = colors.ansi[6],    pad = 8 },
        copy_mode =   { i = "󰆏", txt = "COPY",   bg = colors.brights[3], pad = 8 },
        font_mode =   { i = "󰛖", txt = "FONT",   bg = colors.ansi[7],    pad = 7 },
        help_mode =   { i = "󰞋", txt = "NORMAL", bg = colors.ansi[5],    pad = 9 },
        pick_mode =   { i = "󰢷", txt = "PICK",   bg = colors.ansi[2],    pad = 9 },
    }

    wezterm.on("update-status", function(window, pane)
        -- Workspace name
        local stat = window:active_workspace()
        local stat_color = "#f7768e"

        if window:active_key_table() then
            stat = window:active_key_table()
            stat_color = "#7dcfff"
        end
        if window:leader_is_active() then
            stat = "LDR "
            stat_color = "#bb9af7"
        end

        -- Current working directory
        local username = os.getenv "USER" or os.getenv "LOGNAME" or os.getenv "USERNAME"
        local date = wezterm.strftime("%a %b %-d %I:%M%p")
        -- local hostname = wezterm.hostname()

        local platform = utils.platform()
        local cwd = utils.get_cwd_hostname(pane, platform)
        local hostname = wezterm.hostname()

        -- Time
        local time = wezterm.strftime("%H:%M")

        -- Left status (left of the tab line)
        window:set_left_status(wezterm.format({
            { Foreground = { Color = stat_color } },
            { Text = "  " },
            { Text = nf.oct_table .. "  " .. stat },
            { Text = " |" },
        }))

        -- Right status
        window:set_right_status(wezterm.format({
            { Text = nf.md_folder .. "  " .. cwd },
            -- { Text = " | " },
            -- { Foreground = { Color = "#e0af68" } },
            -- { Text = nf.fa_code .. "  " .. cmd },
            "ResetAttributes",
            { Text = " | " },
            { Text = nf.md_clock .. "  " .. date },
            { Text = " | " },
            { Foreground = { Color = "#e0af68" } },
            { Text = username .. "@" .. hostname .. " " },
        }))
    end)

    wezterm.on("format-tab-title", function(tab, _, _, _, hover)
        local background = colors.brights[1]
        local foreground = colors.foreground

        local name = string.len(tab.tab_title) > 0 and tab.tab_title or getProcessName(tab.active_pane.foreground_process_name)
        local index = tostring(tab.tab_index+1)
        local title = index .. ":" .. name

        if tab.is_active then
            background = colors.brights[7]
            foreground = colors.background
            title = "<" .. title .. ">"
        elseif hover then
            background = colors.brights[8]
            foreground = colors.background
        end

        return {
            { Foreground = { Color = background } },
            { Text = "█" },
            { Background = { Color = background } },
            { Foreground = { Color = foreground } },
            { Text = title },
            { Foreground = { Color = background } },
            { Text = "█" },
        }
    end)
end

return M
