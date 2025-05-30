local constants = require("config.constants")
local icons = require("config.icons")

-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
local capabilities = require('blink.cmp').get_lsp_capabilities()

-- Set the default capabilities for all lsp servers
vim.lsp.config("*", {
    capabilities = capabilities,
})

-- Enable tsserver for JS stuff
-- npm install -g typescript-language-server typescript
require("typescript-tools").setup({
    capabilities = capabilities,
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
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

-- npm install -g vscode-html-languageservice
vim.lsp.config("htmlls", {
    capabilities = capabilities,
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html" },
    root_markers = { "package.json", ".git" },
    init_options = {
        configurationSection = { "html", "css", "javascript" },
        embeddedLanguages = {
            css = true,
            javascript = true,
        },
    },
})
vim.lsp.enable("htmlls")
vim.lsp.enable("html")

-- Use `npm i -g @biomejs/biome`
vim.lsp.enable("biome")

-- Use `npm i -g @olrtg/emmet-language-server` to make this work
vim.lsp.enable("emmet-language-server")

-- JSON language server
-- npm i -g vscode-langservers-extracted
vim.lsp.enable("jsonls")

-- Python language server
-- nvim_lsp.jedi_language_server.setup({})

-- # Lua language server
if vim.fn.executable("lua-language-server") == 1 then
    vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", ".git", vim.uv.cwd(), },
        on_init = function(client)
            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
                    return
                end
            end
        end,
        settings = {
            Lua = {
                runtime = { version = 'LuaJIT' },
                hint = { enable = true },
                diagnostics = { globals = { "vim" } },

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
            }
        }
    })
    vim.lsp.enable("lua_ls")
end

-- Configure how the code errors and such are displayed
vim.diagnostic.config({
    float = {
        border = constants.ui.border,
        source = "if_many",
    },
    jump = {float = true},
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error .. " ",
            [vim.diagnostic.severity.WARN]  = icons.diagnostics.BoldWarn  .. " ",
            [vim.diagnostic.severity.INFO]  = icons.diagnostics.BoldInfo  .. " ",
            [vim.diagnostic.severity.HINT]  = icons.diagnostics.Hint  .. " ",
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



-- Start, Stop, Restart, Log commands
vim.api.nvim_create_user_command("LspStart", function()
    vim.cmd.e()
end, {
    desc = "Starts LSP clients in the current buffer"
})

vim.api.nvim_create_user_command("LspStop", function(opts)
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        if opts.args == "" or opts.args == client.name then
            client:stop(true)
            vim.notify(client.name .. ": stopped")
        end
    end
end, {
    desc = "Stop all LSP clients or a specific client attached to the current buffer.",
    nargs = "?",
    complete = function(_, _, _)
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        local client_names = {}
        for _, client in ipairs(clients) do
            table.insert(client_names, client.name)
        end
        return client_names
    end,
})

vim.api.nvim_create_user_command("LspRestart", function()
    local detach_clients = {}
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        client:stop(true)
        if vim.tbl_count(client.attached_buffers) > 0 then
            detach_clients[client.name] = { client, vim.lsp.get_buffers_by_client_id(client.id) }
        end
    end
    local timer = vim.uv.new_timer()
    if not timer then
        return vim.notify("Servers are stopped but havent been restarted")
    end
    timer:start( 100, 50, vim.schedule_wrap(function()
        for name, client in pairs(detach_clients) do
            local client_id = vim.lsp.start(client[1].config, { attach = false })
            if client_id then
                for _, buf in ipairs(client[2]) do
                    vim.lsp.buf_attach_client(buf, client_id)
                end
                vim.notify(name .. ": restarted")
            end
            detach_clients[name] = nil
        end
        if next(detach_clients) == nil and not timer:is_closing() then
            timer:close()
        end
    end))
end, {
    desc = "Restart all the language client(s) attached to the current buffer",
})

vim.api.nvim_create_user_command("LspLog", function()
    vim.cmd.vsplit(vim.lsp.log.get_filename())
end, {
    desc = "Get all the lsp logs",
})

vim.api.nvim_create_user_command("LspInfo", function()
    vim.cmd("silent checkhealth vim.lsp")
end, {
    desc = "Get all the information about all LSP attached",
})
