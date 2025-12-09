-- Disable stuff for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Global variable(s)
vim.g.have_nerd_font = true

vim.deprecate = function() end
vim.g.clipboard = false
vim.lsp.set_log_level("off")

-- Ignore perl healthchecks with :checkhealth
vim.g.loaded_perl_provider = 0

-- -- Load different steps if in an ssh session (Google AI result, but seems viable. Haven't tested)
-- if os.getenv("SSH_TTY") ~= nil then
--   -- Neovim is running in an SSH session
--   -- Set specific configurations for remote sessions here
--   print("Running in SSH session")
-- else
--   -- Neovim is running on the local machine
--   -- Set configurations for local sessions here
--   print("Running locally")
-- end

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
