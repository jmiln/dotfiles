return {
    -- Show a code outline
    {
        "stevearc/aerial.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        keys = {
            { mode = {"n", "x"}, "<F11>", "<cmd>AerialToggle<cr>", desc = "Toggle Aerial" },
        },
        opts = {
            layout = {
                min_width = 30,
            },
        },
    },
}
