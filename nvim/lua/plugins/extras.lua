return {
    -- Fancy join/ unjoin with extra features
    {
        "Wansmer/treesj",
        keys = {
            { "<leader>j", "<cmd>TSJToggle<cr>", desc = "Toggle treesj" },
        },
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            max_join_length = 300,
            use_default_keymaps = false,
        },
    },

    -- Color any #ffffff style color codes
    {
        "NvChad/nvim-colorizer.lua",
        event = "VeryLazy",
        opts = {},
    },

    -- More in-depth undo
    {
        "mbbill/undotree",
        keys = {
            { "<F5>", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },
        },
    },
    -- Auto-close parentheses and brackets, etc
    {
        "windwp/nvim-autopairs",
        opts = {
            check_ts = true,
            enable_check_bracket_line = false,
            ts_config = {
                lua = { "string" },
                javascript = { "template_string" },
            },
        },
    },
    -- Auto-close html tags
    {
        "windwp/nvim-ts-autotag",
        ft = { "html", "ejs", "css", "scss" },
        opts = {},
    },

    -- Quick changes for surrounding symbols (Quotes, parens, etc)
    {
        "kylechui/nvim-surround",
        version = "^3.0.0",
        event = "VeryLazy",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {},
    },

    -- Boolean toggler
    {
        "rmagatti/alternate-toggler",
        opts = {},
        config = function()
            vim.keymap.set(
                "n",
                "<leader><space>",
                "<cmd>lua require('alternate-toggler').toggleAlternate()<CR>"
            )
        end,
        event = { "BufReadPost" }, -- lazy load after reading a buffer
    },

    -- Search jumper
    -- Cool, but gets in the way of muscle memory
    -- {
    --     "folke/flash.nvim",
    --     event = "VeryLazy",
    --     opts = {
    --         modes = {
    --             search = {
    --                 enabled = true,
    --                 wrap = true,
    --             },
    --             char = {
    --                 jump_labels = true
    --             }
    --         }
    --     },
    -- }
}
