local tsIgnoreCodes = {
    6133,   -- "X" is declared but its value is never used (Covered by biome)
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


vim.lsp.config.tsgo = {
    cmd = { 'tsgo', '--lsp', '--stdio' },
    filetypes = {
        "typescript",
        "typescriptreact",
        "typescript.tsx",
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
            local isTs = string.find(filename, ".ts")

            while idx <= #result.diagnostics do
                local entry = result.diagnostics[idx]
                if isTs and contains(tsIgnoreCodes, entry.code) then
                    table.remove(result.diagnostics, idx)
                else
                    local formatter = require('format-ts-errors')[entry.code]
                    entry.message = formatter and formatter(entry.message) or entry.message

                    idx = idx + 1
                end
            end
            vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
        end,
    },
    root_dir = function(bufnr, on_dir)
        -- The project root is where the LSP can be started from
        -- As stated in the documentation above, this LSP supports monorepos and simple projects.
        -- We select then from the project root, which is identified by the presence of a package
        -- manager lock file.
        local root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
        -- Give the root markers equal priority by wrapping them in a table
        root_markers = vim.fn.has('nvim-0.11.3') == 1 and { root_markers, { '.git' } }
        or vim.list_extend(root_markers, { '.git' })

        -- exclude deno
        if vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc', 'deno.lock' }) then
            return
        end

        -- We fallback to the current working directory if no project root is found
        local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

        on_dir(project_root)
    end,
    -- root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
}

-- Return empty table to satisfy nvim 0.12 loader
return {}
