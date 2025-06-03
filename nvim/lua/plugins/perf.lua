return {
    -- Garbage collect (Shut down inactive LSPs)
    {
        "zeioth/garbage-day.nvim",
        dependencies = "neovim/nvim-lspconfig",
        event = "VeryLazy",
    },
}
