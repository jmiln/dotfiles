local map = vim.api.nvim_set_keymap

map("n", "<f12>", "<cmd>NvimTreeToggle<cr>", {noremap = true, silent = true})
map("x", "<f12>", "<cmd>NvimTreeToggle<cr>", {noremap = true, silent = true})

local nTreeStatus, nvim_tree = pcall(require, "nvim-tree")
if not nTreeStatus then
    return
end

nvim_tree.setup {
    view = {
        adaptive_size = true  -- Resize to an appropriate size when windows/ split around it change
    },
    renderer = {
        indent_markers = {
            enable = true,
            inline_arrows = true,
            icons = {
                corner = "└",
                edge = "│",
                item = "├",
                none = " ",
            },
        },
    --     icons = {
    --         webdev_colors = true,
    --         git_placement = "before",
    --         padding = " ",
    --         symlink_arrow = " ➛ ",
    --         show = {
    --             file = true,
    --             folder = true,
    --             folder_arrow = true,
    --             git = true,
    --         },
    --         glyphs = {
    --             default  = "",
    --             symlink  = "",
    --             bookmark = "",
    --             folder   = {
    --                 arrow_closed = "",
    --                 arrow_open   = "",
    --                 default      = "▸",
    --                 empty        = "▸",
    --                 open         = "▾",
    --                 empty_open   = "▾",
    --                 symlink      = "",
    --                 symlink_open = "",
    --             },
    --             git = {
    --                 unstaged  = "✗",
    --                 staged    = "✓",
    --                 unmerged  = "",
    --                 renamed   = "➜",
    --                 untracked = "★",
    --                 deleted   = "",
    --                 ignored   = "◌",
    --             },
    --         },
    --     },
    }
}

vim.g.nvim_tree_indent_markers  = 1     -- Add lines to better illustrate what's within which folder
vim.g.nvim_tree_add_trailing    = 1     -- Add the trailing / to a file name
vim.g.nvim_tree_respect_buf_cwd = 1     -- Open the tree to the cwd of the open file/ buffer
