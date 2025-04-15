-- vim.deprecate = function() end
vim.g.clipboard = false

-- Load up whatever lua stuff
require("settings")

-- Load up the plugins
require("plugins")

-- Load all the plugin configs
require("config")

-- Load up keybinds and such
require("keybinds")

-- Load up highlighting settings
require("highlight")

-- Load up autocmds
require("autocmds")

-- Load up some utils
-- require("utils")
