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
Plug 'norcalli/nvim-colorizer.lua'

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
Plug 'folke/trouble.nvim'

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

-- Statusline
Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'

vim.call('plug#end')


-- Dependencies
require("plenary")

-- NVIM Comment setup/ settings
require('nvim_comment').setup({
    marker_padding = true,
    comment_empty = true,
    hook = nil
})

-- Statusline
require('lualine').setup({
    options = {
        section_separators = '',
        component_separators = '',
        icons_enabled = false
    },
    extensions = {
        "fugitive"
    }
})

-- NVIM Treesitter setup
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

require('colorizer').setup()
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
nvim_lsp.tsserver.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = {
        -- This makes it so it will stop spitting out the dang "File is a CommonJS module; it may be converted to an ES6 module." error
        -- Via https://www.reddit.com/r/neovim/comments/nv3qh8/how_to_ignore_tsserver_error_file_is_a_commonjs/h1tx1rh
        ["textDocument/publishDiagnostics"] = function(_, _, params, client_id, _, config)
            if params.diagnostics ~= nil then
                local idx = 1
                while idx <= #params.diagnostics do
                    if params.diagnostics[idx].code == 80001 then
                        table.remove(params.diagnostics, idx)
                    else
                        idx = idx + 1
                    end
                end
            end
            vim.lsp.diagnostic.on_publish_diagnostics(_, _, params, client_id, _, config)
        end,
    }
})

-- Configure how the code errors and such show
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = false,
    }
)

-- Trouble settings
require("trouble").setup({
    fold_open = "v",
    fold_closed = ">",
    auto_open = true,
    auto_close = true,
    signs = {
        -- icons / text used for a diagnostic
        error = "[ERROR]",
        warning = "[WARN]",
        hint = "[HINT]",
        information = "[INFO]",
        other = "[OTHER]"
    },
})


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
