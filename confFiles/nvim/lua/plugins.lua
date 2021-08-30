local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

-- Github repos
-- Plug 'airblade/vim-gitgutter'
Plug 'alvan/vim-closetag'
-- Plug 'dense-analysis/ale'
Plug 'farmergreg/vim-lastplace'
Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'
Plug 'Konfekt/FastFold'
-- Plug ('mattn/emmet-vim', {['for'] = ['html', 'ejs', 'css', 'scss']})
Plug ('nvim-treesitter/nvim-treesitter', {['do'] = vim.fn['TSUpdate']})
Plug 'Raimondi/delimitMate'
Plug 'rhysd/committia.vim'
Plug 'sheerun/vim-polyglot'
Plug 'terrortylor/nvim-comment'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'
-- Plug ('tpope/vim-ragtag', {['for'] = ['html', 'ejs', 'css', 'scss']})
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

-- LSP stuffs
Plug 'neovim/nvim-lspconfig'
Plug 'glepnir/lspsaga.nvim'
Plug 'simrat39/symbols-outline.nvim'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-telescope/telescope.nvim'

-- Completion stuffs
-- " Install nvim-cmp
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip' -- Snippets plugin


vim.call('plug#end')


-- Dependencies
require("plenary")

-- NVIM Comment setup/ settings
require('nvim_comment').setup({
    marker_padding = true,
    comment_empty = false,
    hook = nil
})

require('nvim-treesitter.configs').setup({
    ensure_installed = 'maintained',
    highlight = {
      enable = true
    },
    indent = {
      enable = true
    }
})



require('symbols-outline').setup({
    highlight_hovered_item = true,
    show_guides = true,
})

require('gitsigns').setup()


-- In orderfor this to work, need to install some stuff
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#tsserver
-- npm install -g typescript-language-server typescript
-- local nvim_lsp = require("lspconfig")
-- local function on_attach()
--   -- Stuff here?
-- end
-- require'lspconfig'.tsserver.setup{ on_attach=on_attach }
-- local on_attach = function(_, bufnr)
--   vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
-- end
-- nvim_lsp.tsserver.setup {
--   on_attach = on_attach,
--   autostart = true
--     -- function(client)
--     --     client.resolved_capabilities.document_formatting = false
--     --     on_attach(client)
--     -- end
-- }


-- LSP settings
local nvim_lsp = require 'lspconfig'
local on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Enable the following language servers
nvim_lsp.tsserver.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

local check_back_space = function()
  local col = vim.fn.col '.' - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' ~= nil
end
local luasnip = require("luasnip")

-- -- Completion stuffs
require('cmp').setup({
    mapping = {
    --     ['<C-Space>'] = cmp.mapping.complete(),
    --     ['<C-e>']     = cmp.mapping.close(),
    --     ['<CR>']      = cmp.mapping.confirm({
    --         behavior  = cmp.ConfirmBehavior.Replace,
    --         select    = true,
    --     })
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
    formatting = {
        format = function(entry, vim_item)
--             -- set a name for each source
            vim_item.menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
            })[entry.source.name]
            return vim_item
        end,
    },
})
