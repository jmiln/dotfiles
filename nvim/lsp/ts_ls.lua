local jsIgnoreCodes = {
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
local tsIgnoreCodes = {
    6133,   -- "X" is declared but its value is never used (Covered by eslint)
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


-- npm install -g typescript-language-server typescript
return {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
    },
    handlers = {
        -- Modified from:
        -- Via https://www.reddit.com/r/neovim/comments/nv3qh8/how_to_ignore_tsserver_error_file_is_a_commonjs/h1tx1rh
        ["textDocument/publishDiagnostics"] = function(_, result, ctx)
            if result.diagnostics ~= nil then
                local idx = 1

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
            vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx)
        end,
    },
    root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
}
