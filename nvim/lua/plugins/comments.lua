return {
    -- Easy comments
    {
        "numToStr/Comment.nvim",
        opts = {},
        config = function()
            require("Comment").setup {
                -- ignores empty lines
                ignore = "^$",
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            }
        end,
        dependencies = "JoosepAlviste/nvim-ts-context-commentstring",
    },

    -- Comment properly in embedded filetypes (Ejs, etc)
    -- {
    --     "JoosepAlviste/nvim-ts-context-commentstring",
    --     opts = {
    --         enable_autocmd = false,
    --     },
    -- },
}
