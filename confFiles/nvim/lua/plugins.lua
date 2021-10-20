local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

-- TODO These look interesting, have not tried em
--
-- https://github.com/lukas-reineke/indent-blankline.nvim   -- Indent guids/ lines
-- https://github.com/p00f/nvim-ts-rainbow                  -- Rainbow Parens
--
-- TODO End of untried interesting stuff

-- Github repos
-- Plug 'airblade/vim-gitgutter'
Plug 'alvan/vim-closetag'
-- Plug 'dense-analysis/ale'
Plug 'farmergreg/vim-lastplace'
-- Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'
Plug 'Konfekt/FastFold'
-- Plug ('mattn/emmet-vim', {['for'] = ['html', 'ejs', 'css', 'scss']})
Plug 'norcalli/nvim-colorizer.lua'

Plug ('nvim-treesitter/nvim-treesitter', {['do'] = vim.fn['TSUpdate']})
-- Plug 'nvim-treesitter/playground'

-- Auto-close parentheses and brackets, etc
Plug 'steelsojka/pears.nvim'

Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

-- Uses vim splits to display more info when committing to git
Plug 'rhysd/committia.vim'

-- Easy comments
-- Plug 'terrortylor/nvim-comment'

-- Easy comments, but without the weirdness around empty lines  (Swap back to terrortylor's one if the PR is ever merged)
Plug ('paegodu/nvim-comment', {['branch'] = 'empty_lines'})

-- LSP stuffs
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'

-- Open up the locationlist when there are errors
Plug 'folke/trouble.nvim'

-- Git changes in the signcolumn
Plug 'lewis6991/gitsigns.nvim'

-- Completion stuffs
Plug 'hrsh7th/nvim-cmp'       -- The completion plugin itself
Plug 'hrsh7th/cmp-nvim-lsp'   -- Complete bsed on the lsp
Plug 'hrsh7th/cmp-buffer'     -- Complete based on the current buffer
Plug 'hrsh7th/cmp-path'       -- Complete file paths

-- Nvim nvim-tree
Plug 'kyazdani42/nvim-tree.lua'

-- Statusline
Plug 'hoob3rt/lualine.nvim'

vim.call('plug#end')


-- Dependencies
require("plenary")

-- Color any #ffffff style color codes
require('colorizer').setup()

-- Mark changes according to git in the sign-column
require('gitsigns').setup()

require('pears').setup()


