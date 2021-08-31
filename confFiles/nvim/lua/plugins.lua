local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

-- Github repos
-- Plug 'airblade/vim-gitgutter'
Plug 'alvan/vim-closetag'
-- Plug 'dense-analysis/ale'
Plug 'farmergreg/vim-lastplace'
-- Plug 'junegunn/gv.vim'
Plug 'junegunn/vim-easy-align'
Plug 'Konfekt/FastFold'
-- Plug ('mattn/emmet-vim', {['for'] = ['html', 'ejs', 'css', 'scss']})
Plug ('nvim-treesitter/nvim-treesitter', {['do'] = vim.fn['TSUpdate']})
Plug 'nvim-treesitter/playground'

-- Auto-close parentheses and brackets, etc
Plug 'Raimondi/delimitMate'

Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

-- Uses vim splits to display more info when committing to git
Plug 'rhysd/committia.vim'

-- Easy comments
Plug 'terrortylor/nvim-comment'

-- LSP stuffs
Plug 'neovim/nvim-lspconfig'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-telescope/telescope.nvim'

-- Completion stuffs
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
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
    highlight = {
        enable = true
    },
    indent = {
        enable = true
    },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
        },
    }
})

require('gitsigns').setup()


-- In orderfor this to work, need to install some stuff
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#tsserver
-- npm install -g typescript-language-server typescript


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

local cmp = require'cmp'
cmp.setup{
    snippet = {
        expand = function(args)
            return require("luasnip").lsp_expand(args.body)
        end,
    },
    completion = {
        autocomplete = {
            cmp.TriggerEvent.InsertEnter,
            cmp.TriggerEvent.TextChanged,
        },
        completeopt = 'menu,menuone,noselect',
        keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
        keyword_length = 1,
    },
    mapping = {
        ['<S-Tab>']   = cmp.mapping.select_prev_item(),
        ['<Tab>']     = cmp.mapping.select_next_item(),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>']     = cmp.mapping.close(),
        ['<CR>']      = cmp.mapping.confirm({
            behavior  = cmp.ConfirmBehavior.Insert,
            select    = true,
        })
    },
    sources = {
        { name = 'buffer' },
        { name = 'path' },
        -- { name = 'nvim_lsp' }
    },
    confirmation = {
        default_behavior = cmp.ConfirmBehavior.Insert,
    },
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
                nvim_lua = "[Lua]",
            })[entry.source.name]
            return vim_item
        end,
    }
}
