local jsIgnoreCodes = {
    1345,   -- An expression of type 'void' cannot be tested for truthiness. (Ya don't say... I can't set that in js...)
    2322,   -- Type 'string[]' is not assignable to type 'never[]'.
    2339,   -- Property "{0}" does not exist on type "{1}".
    2345,   -- Argument of type '{ name: string; value: any; }' is not assignable to parameter of type 'never'.
    2351,   -- Type has no construct signatures
    2556,   -- A spread argument must either have a tuple type or be passed to a rest parameter
    2732,   -- Cannot find module *.json. Consider using '--resolveJsonModule' to import module with '.json' extension.
    6133,   -- X is declared but its value is never read.
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

-- Local helper function
local function contains (table, val)
    for _, value in ipairs(table) do
        if value == val then
            return true
        end
    end

    return false
end

vim.lsp.config.ts_ls =  {
    init_options = { hostInfo = 'neovim' },
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        -- "typescript",
        -- "typescriptreact",
        -- "typescript.tsx",
    },
    handlers = {
        -- Modified from:
        -- Via https://www.reddit.com/r/neovim/comments/nv3qh8/how_to_ignore_tsserver_error_file_is_a_commonjs/h1tx1rh
        ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
            if result.diagnostics == nil then
                return
            end

            local idx = 1

            -- Allow different diagnostics depending on if it's a .ts or .js file
            local filename = vim.fn.expand("%:p")
            local isJs = string.find(filename, ".js")

            while idx <= #result.diagnostics do
                local entry = result.diagnostics[idx]
                if isJs and contains(jsIgnoreCodes, entry.code) then
                    table.remove(result.diagnostics, idx)
                else
                    local formatter = require('format-ts-errors')[entry.code]
                    entry.message = formatter and formatter(entry.message) or entry.message

                    idx = idx + 1
                end
            end
            vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
        end,
        -- handle rename request for certain code actions like extracting functions / types
        ['_typescript.rename'] = function(_, result, ctx)
            local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
            vim.lsp.util.show_document({
                uri = result.textDocument.uri,
                range = {
                    start = result.position,
                    ['end'] = result.position,
                },
            }, client.offset_encoding)
            vim.lsp.buf.rename()
            return vim.NIL
        end,
    },
    commands = {
        ['editor.action.showReferences'] = function(command, ctx)
            local client = assert(vim.lsp.get_client_by_id(ctx.client_id))
            local file_uri, position, references = unpack(command.arguments)

            local quickfix_items = vim.lsp.util.locations_to_items(references --[[@as any]], client.offset_encoding)
            vim.fn.setqflist({}, ' ', {
                title = command.title,
                items = quickfix_items,
                context = {
                    command = command,
                    bufnr = ctx.bufnr,
                },
            })

            vim.lsp.util.show_document({
                uri = file_uri --[[@as string]],
                range = {
                    start = position --[[@as lsp.Position]],
                    ['end'] = position --[[@as lsp.Position]],
                },
            }, client.offset_encoding)
            ---@diagnostic enable: assign-type-mismatch

            vim.cmd('botright copen')
        end,
    },
    on_attach = function(client, bufnr)
        -- ts_ls provides `source.*` code actions that apply to the whole file. These only appear in
        -- `vim.lsp.buf.code_action()` if specified in `context.only`.
        vim.api.nvim_buf_create_user_command(bufnr, 'LspTypescriptSourceAction', function()
            local source_actions = vim.tbl_filter(function(action)
                return vim.startswith(action, 'source.')
            end, client.server_capabilities.codeActionProvider.codeActionKinds)

            vim.lsp.buf.code_action({
                context = {
                    only = source_actions,
                    diagnostics = {},
                },
            })
        end, {})
    end,
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
}

-- Return empty table to satisfy nvim 0.12 loader
return {}
