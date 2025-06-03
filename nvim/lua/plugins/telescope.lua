return {
    {
        "lewis6991/hover.nvim",
        keys = {
            {
                mode = "n",
                "K",
                function()
                    require("hover").hover()
                end,
                desc = "Show hover desc",
            },
            {
                mode = "n",
                "gK",
                function()
                    require("hover").hover_select()
                end,
                desc = "Show hover desc (select)",
            },
        },
        opts = {
            init = function()
                require("hover.providers.diagnostic")
                require("hover.providers.lsp")
                require("hover.providers.gh")
                require("hover.providers.gh_user")

                vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
                vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
                vim.keymap.set("n", "<C-p>", function()
                    require("hover").hover_switch("previous")
                end, { desc = "hover.nvim (previous source)" })
                vim.keymap.set("n", "<C-n>", function()
                    require("hover").hover_switch("next")
                end, { desc = "hover.nvim (next source)" })
            end,
            preview_opts = {
                border = "rounded",
            },
            preview_window = false,
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
            { "<leader>fb", ":Telescope buffers<CR>", desc = "Search Buffers" },
            { "<leader>fc", ":Telescope resume<CR>", desc = "Resume Last Search" },
            { "<leader>ff", ":Telescope find_files<CR>", desc = "Search Files" },
            { "<leader>fg", ":Telescope live_grep<CR>", desc = "Search File Text" },
            { "<leader>fh", ":Telescope help_tags<CR>", desc = "Search Help" },
            { "<leader>fr", ":Telescope registers<CR>", desc = "Search Registers" },
            { "<leader>fm", ":Telescope marks<CR>", desc = "Search Marks" },
            { "<leader>fs", ":Telescope search_history<CR>", desc = "Search History" },
            { "<leader>fz", ":Telescope spell_suggest<CR>", desc = "Spelling Suggest" },
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
