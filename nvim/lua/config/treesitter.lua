require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true
    },
    indent = {
        enable = true
    },
    ensure_installed = {
        "javascript",
        "typescript",
        "html",
        "css",
        "lua",          -- For the nvim config files
        "comment"       -- Lets it highlight the TODO comments and such
    }
})

