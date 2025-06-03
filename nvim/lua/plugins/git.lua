return {
    -- Git stuff
    "tpope/vim-fugitive",
    "sindrets/diffview.nvim",

    -- Git conflict helper
    {
        "akinsho/git-conflict.nvim",
        version = "*",
        config = true,
    },

    -- Git changes in the signcolumn
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                -- Update these two from over/underscore so they'll actually show up
                delete = { text = "│" },
                topdelete = { text = "│" },
            },
        },
    },

    -- Uses vim splits to display more info when committing to git
    "rhysd/committia.vim",

    -- Better git diff view
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
        opts = {},
        -- keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" } },
    },
}
