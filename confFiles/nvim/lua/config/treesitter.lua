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
        "lua"
    }
})

