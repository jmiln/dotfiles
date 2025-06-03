return {
    -- Easy comments
    {
        "numToStr/Comment.nvim",
        opts = {},
    },

    -- Comment properly in embedded filetypes (Ejs, etc)
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = {
            enable_autocmd = false,
        },
    },
}
