return {
    -- Fancier notification popups in the corner instead of just in the cmd field in the bottom
    {
        "rcarriga/nvim-notify",
        dependencies = "nvim-lua/plenary.nvim",
        opts = {},
        lazy = false,
        config = function()
            local ok, notify = pcall(require, "notify")
            if not ok then
                return
            end
            vim.notify = notify
        end,
    },
}
