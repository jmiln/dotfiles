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
}
