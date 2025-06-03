return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        opts = {
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            indent = { enable = true },
            ensure_installed = {
                "comment", -- Lets it highlight the TODO comments and such
                "css",
                "html",
                "javascript",
                "json",
                "lua", -- For the nvim config files mainly
                "markdown",
                "markdown_inline",
                "regex", -- Ooh, shiny regex
                "tmux", -- For tmux.conf
                "typescript",
                "vimdoc", -- Previously help
                "yaml",
            },
            -- Recommended false if the cli treesitter isn't installed
            auto_install = false,
        },
    },
    -- "nvim-treesitter/playground",
}
