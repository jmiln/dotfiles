-- In order for this to work, need to install some stuff
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#tsserver
-- npm install -g typescript-language-server typescript

local nvim_lsp = require 'lspconfig'
local on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Local helper function
local function contains (table, val)
    for index, value in ipairs(table) do
        if value == val then
            return true
        end
    end

    return false
end

-- Enable the following language servers
nvim_lsp.tsserver.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = {
        -- This makes it stop spitting out the errors specified in ignoreCodes below
        -- Via https://www.reddit.com/r/neovim/comments/nv3qh8/how_to_ignore_tsserver_error_file_is_a_commonjs/h1tx1rh
        ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
            if result.diagnostics ~= nil then
                local idx = 1
                local ignoreCodes = {
                    80001,  -- File is a CommonJS module; it may be converted to an ES6 module.
                    2339,
                    7016,
                    2568,   -- Property 'X' may not exist on type 'Y'. Did you mean 'Z'?
                    6133,   -- 'X' is declared but its value is never used (Covered by eslint)
                }
                while idx <= #result.diagnostics do
                    if contains(ignoreCodes, result.diagnostics[idx].code) then
                        table.remove(result.diagnostics, idx)
                    else
                        idx = idx + 1
                    end
                end
            end
            vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
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

-- This is to enable eslint to work
require'lspconfig'.diagnosticls.setup{
    filetypes = {"javascript", "typescript"},
    init_options = {
        linters = {
            eslint = {
                command = "eslint_d",
                rootPatterns = { ".eslintrc", ".git" },
                debounce = 100,
                args = {
                    "--stdin",
                    "--stdin-filename",
                    "%filepath",
                    "--format",
                    "json"
                },
                sourceName = "eslint",
                parseJson = {
                    errorsRoot = "[0].messages",
                    line       = "line",
                    column     = "column",
                    endLine    = "endLine",
                    endColumn  = "endColumn",
                    message    = "[eslint] ${message} [${ruleId}]",
                    security   = "severity"
                },
                securities = {
                    [2] = "error",
                    [1] = "warning"
                }
            },
        },
        filetypes = {
            javascript = "eslint",
            typescript = "eslint"
        },
        -- formatters = {
        --    eslint_fmt = {
        --         command = 'eslint_d',
        --         args = {
        --             '--fix',
        --             '--fix-to-stdout',
        --             '--stdin',
        --             '--stdin-filename',
        --             '%filepath',
        --         },
        --         rootPatterns = {
        --             '.eslintrc',
        --             '.eslintrc.cjs',
        --             '.eslintrc.js',
        --             '.eslintrc.json',
        --             '.eslintrc.yaml',
        --             '.eslintrc.yml',
        --         },
        --     }
        -- },
        -- formatFiletypes = {
        --     javascript = "eslint_fmt",
        --     typescript = "eslint_fmt"
        -- }
    }
}



-- Trouble settings
require("trouble").setup({
    fold_open = "v",
    fold_closed = ">",
    auto_open = true,
    auto_close = true,
    icons = false,
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
