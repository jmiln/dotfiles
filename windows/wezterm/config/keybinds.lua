local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

-- local function switch_in_direction(dir)
--     return function(window)
--         local tab = window:active_tab()
--         local next_pane = tab:get_pane_direction(dir)
--         if next_pane then
--             tab.swap_active_with_index(next_pane, true)
--         end
--     end
-- end

local keys = {
    -- Split the panes each way
    { key = '\\', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
    { key = '_',  mods = 'LEADER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' }, },

    -- Swap panes
    -- { key = '}', mods = 'LEADER|SHIFT', action = wezterm.action_callback(switch_in_direction("Next")) },
    -- { key = '{', mods = 'LEADER|SHIFT', action = wezterm.action_callback(switch_in_direction("Prev")) },

    -- Move between open panes
    { key = "LeftArrow",  mods = "ALT",    action = act.ActivatePaneDirection("Left") },
    { key = "DownArrow",  mods = "ALT",    action = act.ActivatePaneDirection("Down") },
    { key = "UpArrow",    mods = "ALT",    action = act.ActivatePaneDirection("Up") },
    { key = "RightArrow", mods = "ALT",    action = act.ActivatePaneDirection("Right") },
    { key = "LeftArrow",  mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "DownArrow",  mods = "LEADER", action = act.ActivatePaneDirection("Down") },
    { key = "UpArrow",    mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "RightArrow", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "z",          mods = "LEADER", action = act.TogglePaneZoomState },

    -- Work with the tabs
    { key = 'Space', mods = 'LEADER|CTRL', action = act.ActivateLastTab },
    { key = "c", mods = "LEADER",      action = act.SpawnTab("CurrentPaneDomain") },
    { key = "[", mods = "LEADER",      action = act.ActivateTabRelative(-1) },
    { key = "]", mods = "LEADER",      action = act.ActivateTabRelative(1) },
    { key = "n", mods = "LEADER",      action = act.ShowTabNavigator },
    { key = "1", mods = "LEADER",      action = act.ActivateTab(0) },
    { key = "2", mods = "LEADER",      action = act.ActivateTab(1) },
    { key = "3", mods = "LEADER",      action = act.ActivateTab(2) },
    { key = "4", mods = "LEADER",      action = act.ActivateTab(3) },
    { key = "5", mods = "LEADER",      action = act.ActivateTab(4) },
    { key = "6", mods = "LEADER",      action = act.ActivateTab(5) },
    { key = "7", mods = "LEADER",      action = act.ActivateTab(6) },
    { key = "8", mods = "LEADER",      action = act.ActivateTab(7) },
    { key = "9", mods = "LEADER",      action = act.ActivateTab(8) },
    {
        key = ',',
        mods = 'LEADER',
        action = act.PromptInputLine {
            description = 'Enter new name for tab',
            action = wezterm.action_callback(function(window, pane, line)
                if string.len(line) then
                    window:active_tab():set_title(line)
                end
            end),
        },
    },
};

M.setup = function(config)
    config.keys = keys
    config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 10000 }
end

return M
