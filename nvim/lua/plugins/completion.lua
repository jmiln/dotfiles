local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
    -- Completion menus
    {
        "saghen/blink.cmp",
        -- optional: provides snippets for the snippet source
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                build = "make install_jsregexp",
                dependencies = "rafamadriz/friendly-snippets",
                config = function()
                    require("config.snippets")
                end,
            },
        },

        -- use a release tag to download pre-built binaries
        version = "1.*",
        enabled = function()
            return (vim.bo.buftype ~= "prompt" and vim.b.completion ~= false)
        end,
        opts = {
            keymap = {
                preset = "default",
                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<Tab>"] = { -- Need to keep this, since it doesn't seem to let me use tab normally otherwise
                    function(cmp)
                        if cmp.is_menu_visible() then
                            return cmp.select_next()
                        elseif cmp.snippet_active() then
                            return cmp.snippet_forward()
                        elseif has_words_before() then
                            return cmp.show()
                        end
                    end,
                    "fallback",
                },
                ["<S-Tab>"] = {"select_prev", "snippet_backward", "fallback"},
                ["<CR>"] = { "accept", "fallback" },
                ["<S-CR>"] = {},
                ["<Esc>"] = { 'cancel', 'fallback' },
                ["<C-E>"] = { "cancel", "fallback" },
            },
            appearance = {
                highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
                nerd_font_variant = "mono",
                use_nvim_cmp_as_default = false,
            },
            cmdline = {
                keymap = {
                    preset = "inherit",
                    ["<CR>"] = {},
                    ["<Tab>"] = {"show", "select_next", "fallback"},
                    ["<S-Tab>"] = {"select_prev", "fallback"},
                },
                completion = {
                    menu = {
                        auto_show = false,
                    },
                    list = {
                        selection = {
                            preselect = false,
                            auto_insert = true,
                        },
                    },
                },
            },
            completion = {
                accept = { auto_brackets = { enabled = true } },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 100,
                    window = {
                        border = vim.g.border_style,
                        min_width = 35,
                        direction_priority = {
                            menu_north = { "e", "w" },
                            menu_south = { "e", "w" },
                        },
                    },
                },
                ghost_text = { enabled = false },
                list = {
                    selection = {
                        preselect = true,
                        auto_insert = false,
                    },
                },
                menu = {
                    auto_show = false,
                    border = "rounded",
                    draw = {
                        columns = {
                            { "label", "label_description", gap = 1 },
                            { "kind_icon", "kind", "source_name", gap = 1 },
                        },

                        -- This is cool, but doesn't play nice with the popup background color
                        -- treesitter = { "lsp" }
                    },
                },
                trigger = {
                    show_on_keyword = true,
                    show_on_trigger_character = true,
                    show_on_blocked_trigger_characters = { " ", "\n", "\t" },
                    show_on_insert_on_trigger_character = true,
                    show_on_x_blocked_trigger_characters = { "'", '"', "(", "{", "[" }

                }
            },
            signature = {
                enabled = true,
                window = {
                    border = "rounded",
                },
            },
            snippets = {
                preset = "luasnip",
                -- expand = function(snippet) require('luasnip').lsp_expand(snippet) end,
                -- active = function(filter)
                -- 	if filter and filter.direction then
                -- 		return require('luasnip').jumpable(filter.direction)
                -- 	end
                -- 	return require('luasnip').in_snippet()
                -- end,
                -- jump = function(direction) require('luasnip').jump(direction) end,
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
                providers = {
                    lsp = {
                        min_keyword_length = 2, -- Number of characters to trigger provider
                        score_offset = 0, -- Boost/penalize the score of the items
                    },
                    path = {
                        min_keyword_length = 0,
                    },
                    snippets = {
                        min_keyword_length = 2,
                    },
                    buffer = {
                        min_keyword_length = 4,
                        max_items = 5,
                    },
                },
            },
            fuzzy = { implementation = "prefer_rust_with_warning" },
        },
        opts_extend = { "sources.default" },
    },
    -- {
    --     "hrsh7th/nvim-cmp",
    --     dependencies = {
    --         "hrsh7th/cmp-nvim-lsp", -- Completion output for the lsp
    --         "hrsh7th/cmp-buffer", -- Completion for strings found in the current buffer/ file
    --         -- "hrsh7th/cmp-path",             -- Completion for file paths  (Seems to trigger on blanks/ spaces too often, and will just show paths from root)
    --         "hrsh7th/cmp-nvim-lua", -- Completion for nvim settings and such (vim.lsp.*, etc)
    --         "onsails/lspkind-nvim", -- Show symbols
    --         "L3MON4D3/LuaSnip", -- Snippets
    --         "saadparwaiz1/cmp_luasnip", -- Show snippets in the cmp popup
    --         "rafamadriz/friendly-snippets",
    --     },
    --     config = function()
    --         safeRequire("config.completion")
    --     end,
    -- },


    -- AI Autocomplete stuffs
    {
        "monkoose/neocodeium",
        event = "VeryLazy",
        -- Only enable if the machine has more than 8GB of RAM available
        -- enabled = vim.loop.get_total_memory() > 2^33,
        keys = {
            {
                mode = "i",
                "<A-f>",
                function()
                    require("neocodeium").accept()
                end,
                desc = "Accept suggestion",
            },
        },
        opts = {
            debounce = true,
            silent = true,
            filetypes = {
                TelescopePrompt = false,
            },
            show_label = false,  -- Disable the line number showing the suggestion count
        },
    },
}
