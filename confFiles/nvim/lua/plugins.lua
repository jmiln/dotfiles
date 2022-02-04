local Plug = vim.fn["plug#"]

vim.call("plug#begin", "~/.config/nvim/plugged")

Plug "alvan/vim-closetag"
Plug "farmergreg/vim-lastplace"
Plug "junegunn/vim-easy-align"
Plug "Konfekt/FastFold"
-- Plug ("mattn/emmet-vim", {["for"] = ["html", "ejs", "css", "scss"]})
Plug "norcalli/nvim-colorizer.lua"

-- 'do' mess: https://dev.to/vonheikemen/neovim-using-vim-plug-in-lua-3oom
Plug ("nvim-treesitter/nvim-treesitter", {["do"] = vim.fn["TSUpdate"]})
Plug "nvim-treesitter/playground"

-- Auto-close parentheses and brackets, etc
Plug "steelsojka/pears.nvim"

-- Quick changes for surrounding symbols (Quotes, parens, etc)
Plug "tpope/vim-surround"

-- Uses vim splits to display more info when committing to git
Plug "rhysd/committia.vim"

-- Easy comments
Plug "numToStr/Comment.nvim"

-- LSP stuffs
Plug "neovim/nvim-lspconfig"
Plug "nvim-lua/plenary.nvim"
Plug "nvim-lua/popup.nvim"
Plug "nvim-telescope/telescope.nvim"

-- Open up the locationlist when there are errors
Plug "folke/trouble.nvim"

-- Git stuff
Plug "tpope/vim-fugitive"
    -- Git changes in the signcolumn
Plug "lewis6991/gitsigns.nvim"

-- Completion stuffs
Plug "hrsh7th/nvim-cmp"       -- The completion plugin itself
Plug "hrsh7th/cmp-nvim-lsp"   -- Complete bsed on the lsp
Plug "hrsh7th/cmp-buffer"     -- Complete based on the current buffer
Plug "hrsh7th/cmp-path"       -- Complete file paths
Plug "hrsh7th/cmp-vsnip"      -- Snippets
Plug "hrsh7th/vim-vsnip"      -- Snippets

-- Nvim nvim-tree
Plug "kyazdani42/nvim-tree.lua"

-- Statusline
Plug "nvim-lualine/lualine.nvim"

-- Shut up the diagnostics while I'm in insert mode
Plug "https://gitlab.com/yorickpeterse/nvim-dd.git"

vim.call("plug#end")


-- Dependencies
require("plenary")

-- Color any #ffffff style color codes
require("colorizer").setup()

-- Mark changes according to git in the sign-column
require("gitsigns").setup()

require("pears").setup(function(conf)
    conf.pair("<", ">")
end)

require("dd").setup()
