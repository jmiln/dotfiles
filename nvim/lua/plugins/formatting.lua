local lsp_format_opt = "never"
return {
    -- Auto-format files on save
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format({
                        async = true,
                        lsp_format = lsp_format_opt,
                    })
                end,
                desc = "Format File",
            },
        },
        opts = {
            formatters_by_ft = {
                ["**sh"]        = { "shfmt", "shellcheck" },
                ejs             = { "biome" },
                javascript      = { "biome", "biome-organize-imports"},
                json            = { "biome", "jq" },
                typescript      = { "biome", "biome-organize-imports"},
                typescriptreact = { "biome", "biome-organize-imports"},
                lua             = { "stylua" },
                toml            = { "taplo" }
            },
            notify_on_error = false,
            format_on_save = function(bufnr)
                -- Disable formatting for specific filetypes
                -- * Disable for lua since I like my config files to be formatted in a more readable way
                local ignore_filetypes = { "lua" }
                if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
                    return
                end
                return {
                    timeout_ms = 500,
                    lsp_format = lsp_format_opt,
                }
            end,
            default_format_opts = {
                lsp_format = "fallback",
            },
            formatters = {
                taplo = {
                    args={ "format", "--option", "indent_entries=true", "--option", 'indent_string=    ', "--option", "trailing_newline=true", "-" }
                }
            }
            -- format_on_save = {
            --     -- These options will be passed to conform.format()
            --     timeout_ms = 500,
            --     lsp_format = "fallback",
            -- },
        },
    },
}
