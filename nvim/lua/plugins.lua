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

local constants = require("config.constants")

-- An extra require function to not break everything if something is missing
local function safeRequire(pName, doSetup, setupObj)
    setupObj = setupObj or {}
    local ok, module = pcall(require, pName)
    if not ok then
        vim.notify("Couldn't load plugin: ".. pName)
        return
    end

    if doSetup then
        module.setup(setupObj)
    end
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
        end
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
        }
    },


    -- Color any #ffffff style color codes
    {
        "NvChad/nvim-colorizer.lua",
        event = "VeryLazy",
        opts = {}
    },

    -- More in-depth undo
    {
        "mbbill/undotree",
        keys = {
            { "<F5>", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" }
        }
    },

    -- Preview markdown in a floating window (:Glow)
    {
        "ellisonleao/glow.nvim",
        opts = {
            width = 999,
            height = 999,
            width_ratio  = 0.8,
            height_ratio = 0.8,
        }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = {
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false
            },
            indent = {
                enable = true
            },
            ensure_installed = {
                "comment",      -- Lets it highlight the TODO comments and such
                "css",
                "html",
                "javascript",
                "json",
                "lua",          -- For the nvim config files mainly
                "markdown",
                "markdown_inline",
                "regex",        -- Ooh, shiny regex
                "tmux",         -- For tmux.conf
                "typescript",
                "vimdoc",       -- Previously help
                "yaml",
            },
            -- Recommended false if the cli treesitter isn't installed
            auto_install = false,
        }
    },
    -- "nvim-treesitter/playground",

    -- Add documentation comments (JSDoc style)
    -- {
    --     "danymat/neogen",
    --     opts = {},
    --     dependencies = "nvim-treesitter/nvim-treesitter",
    --     -- tag = "*"
    -- },

    -- Auto-close parentheses and brackets, etc
    {
        "windwp/nvim-autopairs",
        opts = {
            enable_check_bracket_line = false,
            check_ts = true,
            ts_config = {
                lua = {"string"},
                javascript = {"template_string"},
            }
        }
    },

    -- Automatically change strings to `` for template literals (JS)
    {
        "axelvc/template-string.nvim",
        opts = {}
    },

    -- Auto-close html tags
    {
        "windwp/nvim-ts-autotag",
        ft = {"html", "ejs", "css", "scss"},
        opts = {}
    },

    -- Quick changes for surrounding symbols (Quotes, parens, etc)
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        dependencies = {
            -- "nvim-treesitter/nvim-treesitter-textobjects",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {}
    },
    -- {
    --     "nvim-treesitter/nvim-treesitter-textobjects",
    --     opts = {
    --         textobjects = {
    --             swap = {
    --                 enable = true,
    --                 swap_next = {
    --                     ["<leader>a"] = "@parameter.inner",
    --                 },
    --                 swap_previous = {
    --                     ["<leader>A"] = "@parameter.inner",
    --                 },
    --             },
    --         },
    --     }
    -- },

    -- Easy comments
    {
        "numToStr/Comment.nvim",
        opts = {}
    },

    -- Comment properly in embedded filetypes (Ejs, etc)
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = {
            enable_autocmd = false,
        }
    },

    -- LSP stuffs
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "pmizio/typescript-tools.nvim",
        },
        config = function()
            safeRequire("config.lsp")
        end
    },
    {
        "lewis6991/hover.nvim",
        keys = {
            { mode = "n", "K", function() require("hover").hover() end, desc = "Show hover desc" },
            { mode = "n", "gK", function() require("hover").hover_select() end, desc = "Show hover desc (select)" },
        },
        opts = {
            init = function()
                require("hover.providers.lsp")
                require("hover.providers.gh")
                require("hover.providers.gh_user")
            end,
            preview_opts = {
                border = "rounded"
            },
            preview_window = false,
            title = true,
        }
    },
    "nvim-lua/popup.nvim",
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
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
        },
        opts = {
            defaults = {
                file_ignore_patterns = {
                    "node_modules",
                    ".git"
                },
                layout_config = {
                    horizontal = {
                        width = 0.9,
                        preview_width = 0.6
                    }
                    -- other layout configuration here
                },
                borderchars = {
                    "─", "│", "─", "│", "╭", "╮", "╯", "╰",
                },
            }
        }
    },

    -- AI Autocomplete stuffs
    {
        "monkoose/neocodeium",
        event = "VeryLazy",
        -- Only enable if the machine has more than 8GB of RAM available
        enabled = vim.loop.get_total_memory() > 2^33,
        keys = {
            { mode = "i", "<A-f>", function() require("neocodeium").accept() end, desc = "Accept suggestion" },
        },
        opts = {
            debounce = true,
            silent = true,
            filetypes = {
                TelescopePrompt = false
            }
        }
    },

    -- Put errors in the locationlist (<leader>z to open)
    {
        "folke/trouble.nvim",
        event = "VeryLazy",
        dependencies = "nvim-tree/nvim-web-devicons",
        keys = {
            { "<leader>z", "<cmd>TroubleToggle<CR>", desc = "Toggle trouble" },
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
                error       = constants.diagnostic.sign.error,
                warning     = constants.diagnostic.sign.warning,
                information = constants.diagnostic.sign.info,
                hint        = constants.diagnostic.sign.hint,
                other       = "?"
            },
        }
    },

    -- Git stuff
    "tpope/vim-fugitive",
    "sindrets/diffview.nvim",

    -- Git changes in the signcolumn
    {
        "lewis6991/gitsigns.nvim" ,
        opts = {
            signs = {
                -- Update these two from over/underscore so they'll actually show up
                delete       = { text = "│" },
                topdelete    = { text = "│" },
            },
        }
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
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",         -- Completion output for the lsp
            "hrsh7th/cmp-buffer",           -- Completion for strings found in the current buffer/ file
            -- "hrsh7th/cmp-path",             -- Completion for file paths  (Seems to trigger on blanks/ spaces too often, and will just show paths from root)
            "hrsh7th/cmp-nvim-lua",         -- Completion for nvim settings and such (vim.lsp.*, etc)
            "onsails/lspkind-nvim",         -- Show symbols
            "L3MON4D3/LuaSnip",             -- Snippets
            "saadparwaiz1/cmp_luasnip",     -- Show snippets in the cmp popup
            "rafamadriz/friendly-snippets",
        },
        config = function()
            safeRequire("config.completion")
        end,
    },
    {
        "stevearc/aerial.nvim",
        keys = {
            { mode = "n", "<F11>", "<cmd>AerialToggle<cr>", desc = "Toggle Aerial" },
            { mode = "x", "<F11>", "<cmd>AerialToggle<cr>", desc = "Toggle Aerial" },
        },
        opts = {
            layout = {
                min_width = 30
            }
        }
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
                enable = false
            },
            view = {
                adaptive_size = true
            },
            renderer = {
                add_trailing = true,
                indent_markers = {
                    enable = true,
                    inline_arrows = true,
                    icons = {
                        edge   = "│",
                        item   = "├",
                        corner = "└",
                        none   = " ",
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
                theme = "gruvbox_dark",
            },
            extensions = {
                "fugitive",
                -- "lazy",
                "nvim-tree",
                "quickfix",
                -- "trouble"
            },
            sections = {
                lualine_b = {
                    "branch",
                    "diff",
                    -- {
                        -- "diff",
                        -- diff_color = {
                            -- For some reason, the bg colors the text, and the fg colors the background
                            -- added    = "green",
                            -- modified = "yellow",
                            -- removed  = "red",
                            -- added    = { bg = "green",  fg = "#1C1C1C" },
                            -- modified = { bg = "yellow", fg = "#1C1C1C" },
                            -- removed  = { bg = "red",    fg = "#1C1C1C" },
                        -- },
                    -- },
                    {
                        "diagnostics",
                        symbols = {
                            error = constants.diagnostic.sign.error,
                            warn  = constants.diagnostic.sign.warn,
                            info  = constants.diagnostic.sign.info,
                            hint  = constants.diagnostic.sign.hint
                        },
                    }
                },
                lualine_x = {
                    "searchcount",
                    "encoding",
                    "fileformat",
                    "filetype",
                },
            }
        }
    },
})


