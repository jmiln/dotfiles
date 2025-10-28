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
            { mode = { "n", "x" }, "<F12>", "<cmd>NvimTreeToggle<cr>",      desc = "Toggle NvimTree" },
            { mode = "i",          "<F12>", "<esc><cmd>NvimTreeToggle<cr>", desc = "Toggle NvimTree" },
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
            -- Open nvim tree when opening nvim into a directory instead of a file
            local function open_nvim_tree(data)
                local directory = vim.fn.isdirectory(data.file) == 1

                if not directory then
                    return
                end

                vim.cmd.enew()                       -- create a new, empty buffer
                vim.cmd.bw(data.buf)                 -- wipe the directory buffer
                vim.cmd.cd(data.file)                -- change to the directory
                require("nvim-tree.api").tree.open() -- open the tree
            end
            vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

            -- Close nvim tree if it is the last buffer (After closing a buffer)
            vim.api.nvim_create_autocmd("BufEnter", {
                nested = true,
                callback = function()
                    if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
                        vim.cmd "quit"
                    end
                end
            })
        end
    },
}
