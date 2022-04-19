local map = vim.api.nvim_set_keymap

map("n", "<f12>", "<cmd>NvimTreeToggle<cr>", {noremap = true, silent = true})
map("x", "<f12>", "<cmd>NvimTreeToggle<cr>", {noremap = true, silent = true})

require"nvim-tree".setup {
    view = {
        auto_resize = true  -- Resize to an appropriate size when windows/ split around it change
    }
}

vim.g.nvim_tree_indent_markers  = 1     -- Add lines to better illustrate what's within which folder
vim.g.nvim_tree_add_trailing    = 1     -- Add the trailing / to a file name
vim.g.nvim_tree_respect_buf_cwd = 1     -- Open the tree to the cwd of the open file/ buffer

vim.g.nvim_tree_icons = {
    default = "",
    symlink = "",
    folder = {
        arrow_open   = "v",
        arrow_closed = ">",
        default      = "",
        open         = "",
        empty        = "",
        empty_open   = "",
        symlink      = "",
        symlink_open = ""
    },
}

vim.g.nvim_tree_show_icons = {
    files         = 0,
    folder_arrows = 1,
    folders       = 1,
    git           = 0,
}
