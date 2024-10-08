local constants = require("config.constants")

-- In order for this to work, need to install some stuff
-- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#tsserver
-- npm install -g typescript-language-server typescript

local lspStatus, nvim_lsp = pcall(require, "lspconfig")
if not lspStatus then
    vim.notify("Couldn't load lspconfig")
    return
end

local on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Local helper function
local function contains (table, val)
    for index, value in ipairs(table) do
        if value == val then
            return true
        end
    end

    return false
end

-- Enable tsserver for JS stuff
-- nvim_lsp.tsserver.setup({
require("typescript-tools").setup({
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = {
        -- This makes it stop spitting out the errors specified in ignoreCodes below

        -- Modified from:
        -- Via https://www.reddit.com/r/neovim/comments/nv3qh8/how_to_ignore_tsserver_error_file_is_a_commonjs/h1tx1rh
        ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
            if result.diagnostics ~= nil then
                local idx = 1
                local jsIgnoreCodes = {
                    1345,   -- An expression of type 'void' cannot be tested for truthiness. (Ya don't say... I can't set that in js...)
                    2322,   -- Type 'string[]' is not assignable to type 'never[]'.
                    2339,   -- Property "{0}" does not exist on type "{1}".
                    2345,   -- Argument of type '{ name: string; value: any; }' is not assignable to parameter of type 'never'.
                    2351,   -- Type has no construct signatures
                    2556,   -- A spread argument must either have a tuple type or be passed to a rest parameter
                    7016,   -- Could not find a declaration file for module "{0}". "{1}" implicitly has an "any" type.
                    7043,   -- Variable '____' implicitly has an 'any[]' type, but a better type may be inferred from usage.
                    7044,   -- Parameter '____' implicitly has an 'any' type, but a better type may be inferred from usage.
                    7045,   -- Member '____' implicitly has an 'any[]' type, but a better type may be inferred from usage.
                    7047,   -- Rest parameter 'args' implicitly has an 'any[]' type, but a better type may be inferred from usage.
                    2568,   -- Property "X" may not exist on type "Y". Did you mean "Z"?
                    6133,   -- "X" is declared but its value is never used (Covered by eslint)
                    18046,  -- 'err' is of type 'unknown'.
                    80001,  -- File is a CommonJS module; it may be converted to an ES6 module.
                    80007,  -- 'await' has no effect on the type of this expression.
                }
                local tsIgnoreCodes = {
                    6133,   -- "X" is declared but its value is never used (Covered by eslint)
                    80007,  -- 'await' has no effect on the type of this expression.
                }

                -- Allow different diagnostics depending on if it's a .ts or .js file
                local filename = vim.api.nvim_buf_get_name(idx);
                local isTs = string.find(filename, ".ts")
                local isJs = string.find(filename, ".js")

                while idx <= #result.diagnostics do
                    if isTs and contains(tsIgnoreCodes, result.diagnostics[idx].code) then
                        table.remove(result.diagnostics, idx)
                    elseif isJs and contains(jsIgnoreCodes, result.diagnostics[idx].code) then
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

-- Enable eslint for it's JS linting
--  * Apparently eslint needs to be installed in the project now, global install doesn't work
--    - Use `npm install --save-dev eslint` to install it as a dev dependency in each project where it's needed
-- nvim_lsp.eslint.setup({})

nvim_lsp.biome.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

nvim_lsp.html.setup({})
-- Use `npm i -g @olrtg/emmet-language-server` to make this work
nvim_lsp.emmet_language_server.setup({})

-- Lua language server
-- nvim_lsp.lua_ls.setup({
--     on_attach = on_attach,
--     capabilities = capabilities,
-- })

-- Python language server
nvim_lsp.jedi_language_server.setup({})

-- Configure how the code errors and such are displayed
vim.diagnostic.config({
    float = {
        border = constants.ui.border,
        source = "if_many",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    virtual_text = false,
})

-- Have a rounded border when using "K" on something to show the signature_help
vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = constants.ui.border })

vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with( vim.lsp.handlers.signature_help, { border = constants.ui.border })
