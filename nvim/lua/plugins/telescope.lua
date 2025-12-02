return {
    {
        "lewis6991/hover.nvim",
        keys = {
            { "K",     "<cmd>lua require('hover').hover()<cr>",                  desc = "Show hover desc" },
            { "gK",    "<cmd>lua require('hover').hover_select()<cr>",           desc = "Show hover desc (select)" },
            { "<C-p>", "<cmd>lua require('hover').hover_switch('previous')<cr>", desc = "hover.nvim (previous source)" },
            { "<C-n>", "<cmd>lua require('hover').hover_switch('next')<cr>",     desc = "hover.nvim (next source)" },
        },
        opts = {
            preview_opts = {
                border = "rounded",
            },
            preview_window = false,
            providers = {
                "hover.providers.diagnostic",
                "hover.providers.lsp",
                "hover.providers.man",
                "hover.providers.dictionary",
                "hover.providers.gh",
                "hover.providers.gh_user",
            },
            title = true,
        },
    },
    "nvim-lua/popup.nvim",
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            { "<leader>fb", ":Telescope buffers<CR>",        desc = "Search Buffers" },
            { "<leader>fc", ":Telescope resume<CR>",         desc = "Resume Last Search" },
            { "<leader>ff", ":Telescope find_files<CR>",     desc = "Search Files" },
            { "<leader>fg", ":Telescope live_grep<CR>",      desc = "Search File Text" },
            { "<leader>fh", ":Telescope help_tags<CR>",      desc = "Search Help" },
            { "<leader>fr", ":Telescope registers<CR>",      desc = "Search Registers" },
            { "<leader>fm", ":Telescope marks<CR>",          desc = "Search Marks" },
            { "<leader>fs", ":Telescope search_history<CR>", desc = "Search History" },
            { "<leader>fz", ":Telescope spell_suggest<CR>",  desc = "Spelling Suggest" },

            -- Use telescope for spell suggestions
            { "z=",         ":Telescope spell_suggest<CR>", desc = "Spell suggestions" },
        },
        opts = {
            defaults = {
                file_ignore_patterns = {
                    "node_modules",
                    ".git",
                },
                layout_config = {
                    horizontal = {
                        width = 0.9,
                        preview_width = 0.6,
                    },
                    -- other layout configuration here
                },
                borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            },
        },
    },
}
