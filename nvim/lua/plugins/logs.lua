return {
    -- Log inserter +
    {
        "andrewferrier/debugprint.nvim",

        opts = {
            keymaps = {
                -- Put the log with a var below the current line with ALT+-
                -- Put the log without a var below the current line with ALT++
                normal = {
                    variable_below = "<M-->",
                    plain_below = "<M-=>",
                },
            }
        },

        dependencies = {
            "echasnovski/mini.hipatterns",   -- Optional: Needed for line highlighting ('fine-grained' hipatterns plugin)
            "nvim-telescope/telescope.nvim", -- Optional: If you want to use the `:Debugprint search` command with telescope.nvim
        },

        lazy = false, -- Required to make line highlighting work before debugprint is first used
        version = "*", -- Remove if you DON'T want to use the stable version
    },
}
