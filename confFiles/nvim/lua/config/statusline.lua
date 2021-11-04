require("lualine").setup({
    options = {
        component_separators = "",
        icons = false,
        icons_enabled = false,
        section_separators = "",
        theme = "gruvbox_dark",
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = { "filename" },
        lualine_x = {
            { "diagnostics", sources = { "nvim_lsp" } },
            "encoding",
            "fileformat",
            "filetype",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
    extensions = {
        "fugitive",
        "nvim-tree",
        "quickfix"
    }
})

