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

local opts = {
    -- whether to highlight the currently hovered symbol
    -- disable if your cpu usage is higher than you want it
    -- or you just hate the highlight
    -- default: true
    highlight_hovered_item = true,

    -- whether to show outline guides
    -- default: true
    show_guides = true,
}

require('symbols-outline').setup(opts)







-- -- Completion stuffs
-- require('cmp').setup({
--     snippet = {
--         expand = function(args)
--             vim.fn["vsnip#anonymous"](args.body)
--         end,
--     },
--     mapping = {
--         ['<C-y>'] = cmp.mapping.confirm({ select = true }),
--         ['<C-Space>'] = cmp.mapping.complete(),
--         ['<C-e>'] = cmp.mapping.close(),
--         ['<CR>'] = cmp.mapping.confirm({
--             behavior = cmp.ConfirmBehavior.Replace,
--             select = true,
--         }),
--         ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' })
--     },
--     completion = {
--         completeopt = 'menu,menuone,noinsert',
--     },
--     sources = {
--         { name = 'nvim_lsp' },
--         { name = 'vsnip' },
--     },
-- })






-- LSP settings
local nvim_lsp = require 'lspconfig'
local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, 'v', '<leader>ca', '<cmd>lua vim.lsp.buf.range_code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
  vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Enable the following language servers
local servers = { 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end
