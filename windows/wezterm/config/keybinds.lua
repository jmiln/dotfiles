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
    { key = 'r', mods = 'LEADER', action = act.ReloadConfiguration, },

    -- Split the panes each way
    { key = '\\', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
    { key = '_',  mods = 'LEADER|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' }, },

    -- Swap panes
    -- { key = '}', mods = 'LEADER|SHIFT', action = wezterm.action_callback(switch_in_direction("Next")) },
    -- { key = '{', mods = 'LEADER|SHIFT', action = wezterm.action_callback(switch_in_direction("Prev")) },

    -- Move between open panes
    { key = "LeftArrow",  mods = "ALT",    action = act.ActivatePaneDirection("Left") },
    { key = "RightArrow", mods = "ALT",    action = act.ActivatePaneDirection("Right") },
    { key = "UpArrow",    mods = "ALT",    action = act.ActivatePaneDirection("Up") },
    { key = "DownArrow",  mods = "ALT",    action = act.ActivatePaneDirection("Down") },

    { key = "LeftArrow",  mods = "LEADER", action = act.ActivatePaneDirection("Left") },
    { key = "RightArrow", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
    { key = "UpArrow",    mods = "LEADER", action = act.ActivatePaneDirection("Up") },
    { key = "DownArrow",  mods = "LEADER", action = act.ActivatePaneDirection("Down") },

    { key = "z",          mods = "LEADER", action = act.TogglePaneZoomState },

    -- Work with the tabs
    { key = 'Space', mods = 'LEADER|CTRL', action = act.ActivateLastTab },
    { key = "c", mods = "LEADER",      action = act.SpawnTab("CurrentPaneDomain") },
    { key = "[", mods = "LEADER",      action = act.ActivateTabRelative(-1) },
    { key = "]", mods = "LEADER",      action = act.ActivateTabRelative(1) },
    { key = "n", mods = "LEADER",      action = act.ShowTabNavigator },
    {
        key = ',',
        mods = 'LEADER',
        action = act.PromptInputLine {
            description = 'Enter new name for tab',
            action = wezterm.action_callback(function(window, _, line)
                if string.len(line) then
                    window:active_tab():set_title(line)
                end
            end),
        },
    },
};

for i = 1, 9 do
  -- LEADER + number to activate that tab
  table.insert(keys, { key = tostring(i), mods = 'LEADER', action = act.ActivateTab(i - 1), })
end

M.setup = function(config)
    config.keys = keys
    config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 10000 }
end

return M
