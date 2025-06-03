return {
    -- Show a code outline
    {
        "stevearc/aerial.nvim",
        keys = {
            { mode = "n", "<F11>", "<cmd>AerialToggle<cr>", desc = "Toggle Aerial" },
            { mode = "x", "<F11>", "<cmd>AerialToggle<cr>", desc = "Toggle Aerial" },
        },
        opts = {
            layout = {
                min_width = 30,
            },
        },
    },
}
