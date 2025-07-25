return {
    -- Automatically change strings to `` for template literals (JS)
    --  - Seems to have stopped working after a recent nvim update
    --  - Tried puppeteer as well, but had the same issue of just not working at all.
    --    * Presumably, v0.11dev just breaks whatever they're using?
    -- {
    --     -- This one works, but is super aggressive about it, so you can't even put
    --     -- the ${} into a normal string if you wanted to
    --     -- It also screws up the undo history, so it's hard to undo past it
    --     "rxtsel/template-string.nvim",
    --     event = "InsertLeave",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-treesitter/nvim-treesitter",
    --     }
    -- },
    -- {
    --     "axelvc/template-string.nvim",
    --     opts = {
    --         remove_template_string = true,
    --         restore_quotes = {
    --             normal = [["]],
    --         },
    --     },
    -- },
    -- {
    --     "chrisgrieser/nvim-puppeteer",
    --     lazy = false, -- plugin lazy-loads itself. Can also load on filetypes.
    -- },
}

