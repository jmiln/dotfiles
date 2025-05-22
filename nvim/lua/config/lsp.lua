local constants = require("config.constants")

-- In order for this to work, need to install some stuff
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#tsserver
-- npm install -g typescript-language-server typescript

-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
local capabilities = require('blink.cmp').get_lsp_capabilities()

-- Enable tsserver for JS stuff
require("typescript-tools").setup({
    capabilities = capabilities,
    handlers = {
        -- This makes it stop spitting out the errors specified in ignoreCodes below
        ["textDocument/publishDiagnostics"] = require("typescript-tools.api").filter_diagnostics(
            {
                1345,   -- An expression of type 'void' cannot be tested for truthiness. (Ya don't say... I can't set that in js...)
                2322,   -- Type 'string[]' is not assignable to type 'never[]'.
                2339,   -- Property "{0}" does not exist on type "{1}".
                2345,   -- Argument of type '{ name: string; value: any; }' is not assignable to parameter of type 'never'.
                2351,   -- Type has no construct signatures
                2556,   -- A spread argument must either have a tuple type or be passed to a rest parameter
                2732,   -- Cannot find module *.json. Consider using '--resolveJsonModule' to import module with '.json' extension.
                7016,   -- Could not find a declaration file for module "{0}". "{1}" implicitly has an "any" type.
                7043,   -- Variable '____' implicitly has an 'any[]' type, but a better type may be inferred from usage.
                7044,   -- Parameter '____' implicitly has an 'any' type, but a better type may be inferred from usage.
                7045,   -- Member '____' implicitly has an 'any[]' type, but a better type may be inferred from usage.
                7047,   -- Rest parameter 'args' implicitly has an 'any[]' type, but a better type may be inferred from usage.
                2568,   -- Property "X" may not exist on type "Y". Did you mean "Z"?
                18046,  -- 'err' is of type 'unknown'.
                80001,  -- File is a CommonJS module; it may be converted to an ES6 module.
                80007,  -- 'await' has no effect on the type of this expression.
            }
        ),
    }
})

vim.lsp.enable("biome")
vim.lsp.config("biome", {
    capabilities = capabilities,
})

vim.lsp.enable("html")
vim.lsp.config("html", {
    capabilities = capabilities,
})

-- Use `npm i -g @olrtg/emmet-language-server` to make this work
vim.lsp.enable("emmet-language-server")
vim.lsp.config("emmet-language-server", {
    capabilities = capabilities,
})

-- # Lua language server
if vim.fn.executable("lua-language-server") == 1 then
    vim.lsp.enable("lua_ls")
    vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        on_init = function(client)
            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
                    return
                end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                runtime = { version = 'LuaJIT' },
                -- Make the server aware of Neovim runtime files
                workspace = {
                    checkThirdParty = false,
                    library = {
                        vim.env.VIMRUNTIME,
                        -- Depending on the usage, you might want to add additional paths here.
                        "${3rd}/luv/library"
                        -- "${3rd}/busted/library",
                    }
                }
            })
        end,
        settings = {
            Lua = {}
        }
    })
end

-- JSON language server
-- npm i -g vscode-langservers-extracted
vim.lsp.enable("jsonls")
vim.lsp.config("jsonls", {
    capabilities = capabilities,
})


-- Python language server
-- nvim_lsp.jedi_language_server.setup({})

-- Configure how the code errors and such are displayed
vim.diagnostic.config({
    float = {
        border = constants.ui.border,
        source = "if_many",
    },
    jump = {float = true},
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = constants.diagnostic.sign.error .. " ",
            [vim.diagnostic.severity.WARN]  = constants.diagnostic.sign.warn  .. " ",
            [vim.diagnostic.severity.INFO]  = constants.diagnostic.sign.info  .. " ",
            [vim.diagnostic.severity.HINT]  = constants.diagnostic.sign.hint  .. " ",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticError",
            [vim.diagnostic.severity.WARN]  = "DiagnosticWarn",
            [vim.diagnostic.severity.INFO]  = "DiagnosticInfo",
            [vim.diagnostic.severity.HINT]  = "DiagnosticHint",
        },
    },
    underline = { severity = vim.diagnostic.severity.WARN },
    update_in_insert = false,
    virtual_text = false,
    virtual_lines = {
        severity = {
            min = vim.diagnostic.severity.ERROR,
        },
    },
})
