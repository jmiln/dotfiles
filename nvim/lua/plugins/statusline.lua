local icons = require("config.icons")

return {
    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = "nvim-tree/nvim-web-devicons",
        opts = {
            options = {
                -- theme = "gruvbox_dark",
                -- theme = "wombat",
                theme = "onedark",
                -- theme = "base16",
                -- theme = "powerline_dark",
                -- theme = theme(),

                -- Enable these if the >< icons break on the statusline
                -- component_separators = { left = "", right = "" },
                -- section_separators = { left = "", right = "" },
                icon_enabled = true,
            },
            extensions = {
                "fugitive",
                "lazy",
                "nvim-tree",
                "quickfix",
                "trouble",
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = {
                    "branch",
                    {
                        "diff",
                        source = function()
                            local gitsigns = vim.b.gitsigns_status_dict
                            if gitsigns then
                                return {
                                    added    = gitsigns.added,
                                    modified = gitsigns.changed,
                                    removed  = gitsigns.removed,
                                }
                            end
                        end,
                        symbols = {
                            added    = icons.git.LineAdded    .. " ",
                            modified = icons.git.LineModified .. " ",
                            removed  = icons.git.LineRemoved  .. " ",
                        },
                        colored = true,
                        always_visible = false,
                    },
                    {
                        "diagnostics",
                        sources = { "nvim_diagnostic" },
                        sections = { "error", "warn", "info", "hint" },
                        symbols = {
                            error = icons.diagnostics.Error,
                            hint  = icons.diagnostics.Hint,
                            info  = icons.diagnostics.Info,
                            warn  = icons.diagnostics.Warning,
                        },
                        colored = true,
                        update_in_insert = false,
                        always_visible = false,
                    }
                },
                lualine_c = {"filename"},

                lualine_x = {
                    "searchcount",
                    "encoding",
                    {
                        "lsp_status",
                        icon = "", -- f013
                        symbols = {
                            spinner = icons.spinner,
                            done = false,
                            separator = " ",
                        },
                        -- List of LSP names to ignore (e.g., `null-ls`):
                        ignore_lsp = {},
                    },
                    "fileformat",
                    "filetype",
                },
                lualine_y = {"progress"},
                lualine_z = {"location"},
            },
        },
    },
}
