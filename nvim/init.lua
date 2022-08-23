-- " Enable filetype plugins and indention
-- filetype off
-- filetype plugin on
-- filetype plugin indent on       " Turn on filetype specific options

-- Install vim-plug if it's not already there
local fn = vim.fn
if fn.empty(fn.glob('~/.config/nvim/autoload/plug.vim')) > 0 then
    fn.system({"silent", "!curl", "-fLo",  "~/.config/nvim/autoload/plug.vim", "--create-dirs", "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"})
    vim.cmd [[PlugInstall]]
end

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

-- Load up some utils
-- require("utils")
