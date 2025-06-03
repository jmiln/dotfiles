return {
    -- Auto-format files on save
    {
        "stevearc/conform.nvim",
        keys = {
            {
                "=",
                function()
                    require("conform").format({ async = true })
                end,
                desc = "Format File",
            },
        },
        opts = {
            formatters_by_ft = {
                ejs = { "biome" },
                javascript = { "biome" },
                json = { "biome" },
                typescript = { "biome" },
                typescriptreact = { "biome" },
                lua = { "stylua" },
            },
            default_format_opts = {
                lsp_format = "fallback",
            },
            -- format_on_save = {
            --     -- These options will be passed to conform.format()
            --     timeout_ms = 500,
            --     lsp_format = "fallback",
            -- },
        },
    },
}
