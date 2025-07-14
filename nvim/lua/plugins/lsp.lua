return {
    -- LSP stuffs
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile", "BufEnter" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            -- {
            --     "pmizio/typescript-tools.nvim",
            --     dependencies = {
            --         "nvim-lua/plenary.nvim",
            --         "neovim/nvim-lspconfig",
            --     },
            --     opts = {},
            -- },
            "saghen/blink.cmp",
        },
        config = function()
            require("core.lsp")
        end,
    },

    -- Code actions / Diagnostic display
    {
        "rachartier/tiny-code-action.nvim",
        dependencies = {
            {"nvim-lua/plenary.nvim"},
            {"nvim-telescope/telescope.nvim"},
        },
        event = "LspAttach",
        opts = {
            picker = "telescope",
            opts = {
                hotkeys = true,
                hotkeys_mode = "text_diff_based"
            }
        },
        init = function()
            vim.keymap.set("n", "<leader>ca", function()
                require("tiny-code-action").code_action()
            end, { noremap = true, silent = true })
        end
    },
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy", -- Or `LspAttach`
        priority = 1000, -- needs to be loaded in first
        config = function()
            require('tiny-inline-diagnostic').setup()
            vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
        end
    },
}

