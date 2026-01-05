return {
    -- Auto-format files on save
    {
        "stevearc/conform.nvim",
        keys = {
            {
                "<leader>cf",
                function()
                    require("conform").format({
                        async = true,
                        lsp_format = "fallback",
                    })
                end,
                desc = "Format File",
            },
        },
        opts = {
            formatters_by_ft = {
                ejs             = { "biome" },
                javascript      = { "biome" },
                json            = { "biome" },
                typescript      = { "biome" },
                typescriptreact = { "biome" },
                lua             = { "stylua" },
                toml            = { "taplo" }
            },
            default_format_opts = {
                lsp_format = "fallback",
            },
            formatters = {
                taplo = {
                    args={
                        "format",
                        "--option",
                        "indent_entries=true",
                        "--option",
                        'indent_string=    ',
                        "--option",
                        "trailing_newline=true",
                        "-",
                    }
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
