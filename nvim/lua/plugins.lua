local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Disable these for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local icons = require("config.icons")

-- An extra require function to not break everything if something is missing
local function safeRequire(pName, doSetup, setupObj)
    setupObj = setupObj or {}
    local ok, module = pcall(require, pName)
    if not ok then
        vim.notify("Couldn't load plugin: " .. pName)
        return
    end

    if doSetup then
        module.setup(setupObj)
    end
end

local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

safeRequire("lazy", true, {
    -- Notifications
    -- Fancier notification popups in the corner instead of just in the cmd field in the bottom
    {
        "rcarriga/nvim-notify",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            local ok, notify = pcall(require, "notify")
            if not ok then
                return
            end
            vim.notify = notify
        end,
    },

    -- Easily align stuff
    {
        "echasnovski/mini.align",
        version = "*",
        opts = {
            mappings = {
                start = "ga",
                start_with_preview = "gA",
            },
        },
    },

    -- Garbage collect (Shut down inactive LSPs)
    {
        "zeioth/garbage-day.nvim",
        dependencies = "neovim/nvim-lspconfig",
        event = "VeryLazy",
    },

    -- Fancy join/ unjoin with extra features
    {
        "Wansmer/treesj",
        keys = {
            { "<leader>j", "<cmd>TSJToggle<cr>", desc = "Toggle treesj" },
        },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("treesj").setup({
                use_default_keymaps = false,
            })
        end,
    },

    -- Color any #ffffff style color codes
    {
        "NvChad/nvim-colorizer.lua",
        event = "VeryLazy",
        opts = {},
    },

    -- More in-depth undo
    {
        "mbbill/undotree",
        keys = {
            { "<F5>", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },
        },
    },

    -- Support for icons
    {
        "nvim-tree/nvim-web-devicons",
        opts = {},
    },

    -- Preview markdown in a floating window (:Glow)
    { -- Not supported anymore, but my preferred option
        "ellisonleao/glow.nvim",
        opts = {
            width = 999,
            height = 999,
            width_ratio = 0.8,
            height_ratio = 0.8,
        },
    },
    -- {
    --     'MeanderingProgrammer/render-markdown.nvim',
    --     dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    --     opts = {
    --         enabled = false,
    --         completions = {
    --             blink = {
    --                 enabled = true,
    --             },
    --         },
    --     },
    -- },
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
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

    -- Display / explain regex patterns (Looks cool, but doesn't seem to work with js stuff)
    -- {
    --     "OXY2DEV/patterns.nvim",
    --     opts = {},
    -- },

    -- Add documentation comments (JSDoc style)
    -- {
    --     "danymat/neogen",
    --     opts = {},
    --     dependencies = "nvim-treesitter/nvim-treesitter",
    --     -- tag = "*"
    -- },

    -- Log inserter +
    {
        "andrewferrier/debugprint.nvim",

        opts = {
            keymaps = {
                -- Put the log with a var below the current line with ALT+-
                -- Put the log without a var below the current line with ALT++
                normal = {
                    variable_below = "<M-->",
                    plain_below = "<M-=>",
                },
            }
        },

        dependencies = {
            "echasnovski/mini.hipatterns",   -- Optional: Needed for line highlighting ('fine-grained' hipatterns plugin)
            "nvim-telescope/telescope.nvim", -- Optional: If you want to use the `:Debugprint search` command with telescope.nvim
        },

        lazy = false, -- Required to make line highlighting work before debugprint is first used
        version = "*", -- Remove if you DON'T want to use the stable version
    },

    -- Auto-close parentheses and brackets, etc
    {
        "windwp/nvim-autopairs",
        opts = {
            check_ts = true,
            enable_check_bracket_line = false,
            ts_config = {
                lua = { "string" },
                javascript = { "template_string" },
            },
        },
    },

    -- Auto-format files on save
    {
        "stevearc/conform.nvim",
        keys = {
            {
                "=",
                function()
                    require("conform").format({ async = true })
                end,
                desc = "Format File",
            },
        },
        opts = {
            formatters_by_ft = {
                ejs = { "biome" },
                javascript = { "biome" },
                json = { "biome" },
                typescript = { "biome" },
                typescriptreact = { "biome" },
                lua = { "stylua" },
            },
            default_format_opts = {
                lsp_format = "fallback",
            },
            -- format_on_save = {
            --     -- These options will be passed to conform.format()
            --     timeout_ms = 500,
            --     lsp_format = "fallback",
            -- },
        },
    },

    -- Automatically change strings to `` for template literals (JS)
    --  - Seems to have stopped working after a recent nvim update
    --  - Tried puppeteer as well, but had the same issue of just not working at all.
    --    * Presumably, v0.11dev just breaks whatever they're using?
    -- {
    --     -- This one works, but is super aggressive about it, so you can't even put
    --     -- the ${} into a normal string if you wanted to
    --     -- It also screws up the undo history, so it's hard to undo past it
    --     "rxtsel/template-string.nvim",
    --     event = "InsertLeave",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",
    --         "nvim-treesitter/nvim-treesitter",
    --     }
    -- },
    -- {
    --     "axelvc/template-string.nvim",
    --     opts = {
    --         remove_template_string = true,
    --         restore_quotes = {
    --             normal = [["]],
    --         },
    --     },
    -- },
    -- {
    --     "chrisgrieser/nvim-puppeteer",
    --     lazy = false, -- plugin lazy-loads itself. Can also load on filetypes.
    -- },

    -- Auto-close html tags
    {
        "windwp/nvim-ts-autotag",
        ft = { "html", "ejs", "css", "scss" },
        opts = {},
    },

    -- Quick changes for surrounding symbols (Quotes, parens, etc)
    {
        "kylechui/nvim-surround",
        version = "^3.0.0",
        event = "VeryLazy",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {},
    },

    -- Easy comments
    {
        "numToStr/Comment.nvim",
        opts = {},
    },

    -- Comment properly in embedded filetypes (Ejs, etc)
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = {
            enable_autocmd = false,
        },
    },

    -- LSP stuffs
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile", "BufEnter" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "pmizio/typescript-tools.nvim",
                dependencies = {
                    "nvim-lua/plenary.nvim",
                    "neovim/nvim-lspconfig",
                },
                opts = {},
            },
            "saghen/blink.cmp",
        },
        config = function()
            safeRequire("config.lsp")
        end,
    },
    {
        "lewis6991/hover.nvim",
        keys = {
            {
                mode = "n",
                "K",
                function()
                    require("hover").hover()
                end,
                desc = "Show hover desc",
            },
            {
                mode = "n",
                "gK",
                function()
                    require("hover").hover_select()
                end,
                desc = "Show hover desc (select)",
            },
        },
        opts = {
            init = function()
                require("hover.providers.diagnostic")
                require("hover.providers.lsp")
                require("hover.providers.gh")
                require("hover.providers.gh_user")

                vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
                vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
                vim.keymap.set("n", "<C-p>", function()
                    require("hover").hover_switch("previous")
                end, { desc = "hover.nvim (previous source)" })
                vim.keymap.set("n", "<C-n>", function()
                    require("hover").hover_switch("next")
                end, { desc = "hover.nvim (next source)" })
            end,
            preview_opts = {
                border = "rounded",
            },
            preview_window = false,
            title = true,
        },
    },
    "nvim-lua/popup.nvim",
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            { "<leader>fb", ":Telescope buffers<CR>", desc = "Search Buffers" },
            { "<leader>fc", ":Telescope resume<CR>", desc = "Resume Last Search" },
            { "<leader>ff", ":Telescope find_files<CR>", desc = "Search Files" },
            { "<leader>fg", ":Telescope live_grep<CR>", desc = "Search File Text" },
            { "<leader>fh", ":Telescope help_tags<CR>", desc = "Search Help" },
            { "<leader>fr", ":Telescope registers<CR>", desc = "Search Registers" },
            { "<leader>fm", ":Telescope marks<CR>", desc = "Search Marks" },
            { "<leader>fs", ":Telescope search_history<CR>", desc = "Search History" },
            { "<leader>fz", ":Telescope spell_suggest<CR>", desc = "Spelling Suggest" },
        },
        opts = {
            defaults = {
                file_ignore_patterns = {
                    "node_modules",
                    ".git",
                },
                layout_config = {
                    horizontal = {
                        width = 0.9,
                        preview_width = 0.6,
                    },
                    -- other layout configuration here
                },
                borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            },
        },
    },

    -- Task runner plugin
    -- {
    --     "DanWlker/toolbox.nvim",
    --     keys = {
    --         {
    --             "<leader>st",
    --             function()
    --                 require("toolbox").show_picker()
    --             end,
    --             desc = "[S]earch [T]oolbox",
    --             mode = { "n", "v" },
    --         },
    --     },
    --     -- Remove this if you don't need to always see telescope's ui when triggering toolbox
    --     -- keys = {} will cause toolbox to lazy load, therefore if it loads before telescope you
    --     -- will see the default vim.ui.select.
    --     --
    --     -- If you want to use your custom vim.ui.select overrides, remember to add it into dependencies
    --     -- to ensure it loads first
    --     --
    --     -- Note: This is safe to remove, it is just to ensure plugins load in the correct order
    --     dependencies = { "nvim-telescope/telescope.nvim" },
    --     opts = {
    --         commands = {
    --             {
    --                 name = "Format Json",
    --                 execute = "%!jq --indent 4 '.'",
    --             },
    --             {
    --                 name = "Reload plugin",
    --                 execute = function(name)
    --                     package.loaded[name] = nil
    --                     require(name).setup()
    --                 end,
    --                 tags = { "first", "second" },
    --             },
    --         },
    --     },
    --     config = true,
    -- },
    -- {
    --     "stevearc/overseer.nvim",
    --     keys = {
    --         { "<leader>sr", "<cmd>OverseerRun<CR>", desc = "Run Overseer", mode = { "n", "v" } },
    --         { "<leader>st", "<cmd>OverseerToggle<CR>", desc = "Toggle Overseer", mode = { "n", "v" } },
    --     },
    --     opts = {},
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
        },
    },

    -- Put errors in the locationlist (<leader>z to open)
    {
        "folke/trouble.nvim",
        event = "VeryLazy",
        dependencies = "nvim-tree/nvim-web-devicons",
        keys = {
            { "<leader>z", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Toggle trouble" },
        },
        -- Trouble settings (Show the diagnostics quickfix window automatically)
        opts = {
            icons = {
                indent = {
                    middle = " ",
                    last = " ",
                    top = " ",
                    ws = "│  ",
                },
            },
            modes = {
                diagnostics = {
                    groups = {
                        { "filename", format = "{file_icon} {basename:Title} {count}" },
                    },
                },
            },
            signs = {
                -- icons / text used for a diagnostic
                error       = icons.diagnostics.Error,
                warning     = icons.diagnostics.Warn,
                information = icons.diagnostics.BoldInfo,
                hint        = icons.diagnostics.Hint,
                other = "?",
            },
        },
    },

    -- Git stuff
    "tpope/vim-fugitive",
    "sindrets/diffview.nvim",

    -- Git conflict helper
    {
        "akinsho/git-conflict.nvim",
        version = "*",
        config = true,
    },

    -- Git changes in the signcolumn
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                -- Update these two from over/underscore so they'll actually show up
                delete = { text = "│" },
                topdelete = { text = "│" },
            },
        },
    },

    -- Uses vim splits to display more info when committing to git
    "rhysd/committia.vim",

    -- Better git diff view
    {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
        opts = {},
        -- keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" } },
    },

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
                ["<Tab>"] = {
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
                ["<S-Tab>"] = {
                    function(cmp)
                        if cmp.is_menu_visible() then
                            return cmp.select_prev()
                        elseif cmp.snippet_active() then
                            return cmp.snippet_backward()
                        end
                    end,
                    "fallback",
                },
                ["<CR>"] = { "accept", "fallback" },
                ["<S-CR>"] = {},
                -- ['<Esc>'] = { 'cancel', 'fallback' },
                ["<C-E>"] = { "cancel", "fallback" },
            },

            appearance = {
                highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
                nerd_font_variant = "mono",
                use_nvim_cmp_as_default = false,
            },
            cmdline = {
                keymap = { preset = "inherit" },
                completion = {
                    menu = {
                        auto_show = true,
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
    {
        "stevearc/aerial.nvim",
        keys = {
            { mode = "n", "<F11>", "<cmd>AerialToggle<cr>", desc = "Toggle Aerial" },
            { mode = "x", "<F11>", "<cmd>AerialToggle<cr>", desc = "Toggle Aerial" },
        },
        opts = {
            layout = {
                min_width = 30,
            },
        },
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
    },

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
})
