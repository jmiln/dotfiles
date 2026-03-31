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
        -- "typescript",
        -- "typescriptreact",
        -- "typescript.tsx",
    },
    handlers = {
        ["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
            if result.diagnostics == nil then
                return
            end

            local idx = 1
            while idx <= #result.diagnostics do
                local entry = result.diagnostics[idx]
                if contains(tsIgnoreCodes, entry.code) then
                    table.remove(result.diagnostics, idx)
                else
                    local formatter = require('format-ts-errors')[entry.code]
                    entry.message = formatter and formatter(entry.message) or entry.message
                    idx = idx + 1
                end
            end
            vim.lsp.handlers["textDocument/publishDiagnostics"](_, result, ctx, config)
        end,
    },
    root_dir = function(bufnr, on_dir)
        -- exclude deno
        if vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc', 'deno.lock' }) then
            return
        end

        -- Prioritise tsconfig.json as the root since that's what tsgo needs.
        -- Fall back to lock files (monorepo-friendly), then .git, then cwd.
        local tsconfig_root = vim.fs.root(bufnr, { 'tsconfig.json', 'jsconfig.json' })
        if tsconfig_root then
            on_dir(tsconfig_root)
            return
        end

        local lock_files = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock' }
        local project_root = vim.fs.root(bufnr, lock_files)
            or vim.fs.root(bufnr, { '.git' })
            or vim.fn.getcwd()

        on_dir(project_root)
    end,
}

-- Return empty table to satisfy nvim 0.12 loader
return {}
