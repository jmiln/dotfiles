-- Global variable(s)
vim.g.have_nerd_font = true

vim.deprecate = function() end
vim.g.clipboard = false

-- Load up whatever lua stuff
require("config.options")

-- Load up the plugins
-- require("plugins")
require("core.lazy")

-- Load all the plugin configs
-- require("config")

-- Load up keybinds and such
require("config.keybinds")

-- Load up highlighting settings
require("config.highlight")

-- Load up autocmds
require("config.autocmds")

-- Load up some utils
-- require("utils")
