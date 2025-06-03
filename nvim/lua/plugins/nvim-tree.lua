return {
    -- Support for icons
    {
        "nvim-tree/nvim-web-devicons",
        opts = {},
    },

    -- Nvim file explorer/ tree
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = "nvim-tree/nvim-web-devicons",
        -- tag = "nightly",
        event = "VeryLazy",
        keys = {
            { mode = "n", "<F12>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
            { mode = "x", "<F12>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
        },
        opts = {
            respect_buf_cwd = true,
            filesystem_watchers = {
                enable = false,
            },
            view = {
                adaptive_size = true,
            },
            renderer = {
                add_trailing = true,
                indent_markers = {
                    enable = true,
                    inline_arrows = true,
                    icons = {
                        edge = "│",
                        item = "├",
                        corner = "└",
                        none = " ",
                    },
                },
            },

            -- Disable netrw / open when not opening a file
            disable_netrw = true,
            hijack_unnamed_buffer_when_opening = true,
            hijack_netrw = true,
        },
        init = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1
        end
    },
}
