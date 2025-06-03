local constants = require("config.constants")
local icons = require("config.icons")

-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Set the default capabilities for all lsp servers
vim.lsp.config("*", {
    capabilities = capabilities,
})

vim.lsp.enable({
    "ts_ls",
    "html",
    "htmlls",
    "jsonls",
    "lua_ls",
    "emmet_language_server",
    "biome",
})

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
