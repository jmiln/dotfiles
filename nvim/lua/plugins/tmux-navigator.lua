return {
    -- {
    --     "christoomey/vim-tmux-navigator",
    --     cmd = {
    --         "TmuxNavigateLeft",
    --         "TmuxNavigateDown",
    --         "TmuxNavigateUp",
    --         "TmuxNavigateRight",
    --     },
    --     keys = {
    --         { "<M-Left>",  "<cmd>:TmuxNavigateLeft<cr>" },
    --         { "<M-Right>", "<cmd>:TmuxNavigateRight<cr>" },
    --         { "<M-Down>",  "<cmd>:TmuxNavigateDown<cr>" },
    --         { "<M-Up>",    "<cmd>:TmuxNavigateUp<cr>" },
    --     },
    -- },
    {
        "alexghergh/nvim-tmux-navigation",
        enabled = vim.fn.executable("tmux") == 1,
        event = vim.env.TMUX ~= nil and "VeryLazy" or nil,
        opts = {
            disable_when_zoomed = true,
            keybindings = {
                left = "<M-Left>",
                down = "<M-Down>",
                up = "<M-Up>",
                right = "<M-Right>",
                -- last_active = "<M-\\>",
                -- next = "<C-Space>",
            },
        },
    },
}
