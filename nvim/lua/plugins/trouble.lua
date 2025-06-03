local icons = require("config.icons")

return {
    -- Put errors in the locationlist (<leader>z to open)
    {
        "folke/trouble.nvim",
        event = "VeryLazy",
        dependencies = "nvim-tree/nvim-web-devicons",
        keys = {
            { "<leader>z", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Toggle trouble" },
        },
        -- Trouble settings (Show the diagnostics quickfix window automatically)
        opts = {
            icons = {
                indent = {
                    middle = " ",
                    last = " ",
                    top = " ",
                    ws = "│  ",
                },
            },
            modes = {
                diagnostics = {
                    groups = {
                        { "filename", format = "{file_icon} {basename:Title} {count}" },
                    },
                },
            },
            signs = {
                -- icons / text used for a diagnostic
                error       = icons.diagnostics.Error,
                warning     = icons.diagnostics.Warn,
                information = icons.diagnostics.BoldInfo,
                hint        = icons.diagnostics.Hint,
                other = "?",
            },
        },
    },
}
