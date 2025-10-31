return {
    -- Garbage collect (Shut down inactive LSPs)
    {
        "zeioth/garbage-day.nvim",
        dependencies = "neovim/nvim-lspconfig",
        event = "VeryLazy",
    },

    -- Turns stuff off when opening large files
    {
        "pteroctopus/faster.nvim"
    },
}
