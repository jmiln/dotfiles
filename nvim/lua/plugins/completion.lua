local has_words_before = function()
    local unpack = unpack or table.unpack
    local _, col = unpack(vim.api.nvim_win_get_cursor(0))
    if not col or col <= 0 then
        return false
    end

    local current_line = vim.api.nvim_get_current_line()
    local char_before_cursor = current_line:sub(col, col)
    return not char_before_cursor:match("%s")
end

local getFuzzy = function()
    local os_name = jit.os
    if os_name == "Linux" then
        return "prefer_rust_with_warning"
    else
        return "lua"
    end
end

return {
    -- Completion menus
    {
        "saghen/blink.cmp",
        dependencies = {
            { "rafamadriz/friendly-snippets" },
            { "joelazar/blink-calc" },
            { "moyiz/blink-emoji.nvim" },
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
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
                ["<CR>"] = { "accept", "fallback" },
                ["<S-CR>"] = {},
                ["<Esc>"] = { "cancel", "fallback" },
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
                    ["<Tab>"] = { "show", "select_next", "fallback" },
                    ["<S-Tab>"] = { "select_prev", "fallback" },
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
                    show_on_x_blocked_trigger_characters = { "'", '"', "(", "{", "[" },
                },
            },
            signature = {
                enabled = true,
                window = {
                    border = "rounded",
                },
            },
            snippets = {
                -- Function to use when expanding LSP provided snippets
                expand = function(snippet)
                    vim.snippet.expand(snippet)
                end,
                -- Function to use when checking if a snippet is active
                active = function(filter)
                    return vim.snippet.active(filter)
                end,
                -- Function to use when jumping between tab stops in a snippet, where direction can be negative or positive
                jump = function(direction)
                    vim.snippet.jump(direction)
                end,
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer", "calc", "emoji" },
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
                        opts = {
                            friendly_snippets = true,
                        },
                    },
                    buffer = {
                        min_keyword_length = 4,
                        max_items = 5,
                    },
                    calc = {
                        name = "Calc",
                        module = "blink-calc",
                    },
                    emoji = {
                        name = "Emoji",
                        module = "blink-emoji",
                    },
                },
            },
            fuzzy = {
                -- Function here to make it use lua unless it's on Linux
                --  - Mainly an issue with it refusing to download the default one on Windows
                implementation = getFuzzy(),
            },
        },
        opts_extend = { "sources.default" },
    },

    -- AI Autocomplete stuffs
    {
        "monkoose/neocodeium",
        event = "VeryLazy",
        enabled = jit.os == "Linux", -- Been having issues getting it to behave on Windows
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
            show_label = false, -- Disable the line number showing the suggestion count
        },
    },
}
