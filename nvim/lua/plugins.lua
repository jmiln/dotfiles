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

local constants = require("config.constants")

-- An extra require function to not break everything if something is missing
function safeRequire(pName, doSetup, setupObj)
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
    -- "folke/noice.nvim" seems to be an upcoming alternative for notifications with more features
    -- {
    --     "j-hui/fidget.nvim",    -- Seems to be pretty nice, but a little wonky currently
    --     config = function()
    --         safeRequire("fidget", true, {
    --             notification = {
    --                 override_vim_notify = true,
    --             }
    --         })
    --     end
    -- },
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
        version = '*',
        config = function()
            safeRequire("mini.align", true, {
                mappings = {
                    start = 'ga',
                    start_with_preview = 'gA',
                },
            })
        end
    },


    -- Color any #ffffff style color codes
    {
        "NvChad/nvim-colorizer.lua",
        event = "VeryLazy",
        config = function()
            safeRequire("colorizer", true)
        end
    },

    -- Rainbow parens (Nice to have, but doesn't update cleanly)
    -- "HiPhish/rainbow-delimiters.nvim",

    -- Show what matches with the closing paren/ bracket of the current line
    -- {
    --     "briangwaltney/paren-hint.nvim",
    --     config = function()
    --         safeRequire("paren-hint", true, {
    --             anywhere_on_line       = true,
    --             include_paren          = true,
    --             show_same_line_opening = false,
    --             -- start_with_comment     = true,
    --         })
    --     end
    -- },

    -- More in-depth undo
    {
        "mbbill/undotree",
        config = function()
            vim.api.nvim_set_keymap("n", "<F5>", ":UndotreeToggle<CR>", {noremap = true, silent = true});
        end
    },

    -- Preview markdown in a floating window (:Glow)
    {
        "ellisonleao/glow.nvim",
        config = function()
            safeRequire("glow", true, {
                width = 999,
                height = 999,
                width_ratio  = 0.8,
                height_ratio = 0.8,
            })
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            safeRequire("nvim-treesitter.configs", true, {
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
                },
                -- Recommended false if the cli treesitter isn't installed
                auto_install = false,
            })
        end,
    },
    -- "nvim-treesitter/playground",

    -- Add documentation comments (JSDoc style)
    -- {
    --     "danymat/neogen",
    --     config = function()
    --         safeRequire("neogen", true)
    --     end,
    --     dependencies = "nvim-treesitter/nvim-treesitter",
    --     -- tag = "*"
    -- },

    -- Auto-close parentheses and brackets, etc
    {
        "windwp/nvim-autopairs",
        config = function()
            safeRequire('nvim-autopairs', true, {
                enable_check_bracket_line = false,
                check_ts = true,
                ts_config = {
                    lua = {'string'},
                    javascript = {'template_string'},
                }
            })
        end
    },

    -- Automatically change strings to `` for template literals (JS)
    {
        "axelvc/template-string.nvim",
        config = function()
            safeRequire("template-string", true)
        end
    },

    -- Auto-close html tags
    {
        "windwp/nvim-ts-autotag",
        ft = {"html", "ejs", "css", "scss"},
        config = function()
            safeRequire("nvim-ts-autotag", true)
        end
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
        config = function()
            safeRequire("nvim-surround", true)
        end
    },
    -- {
    --     "nvim-treesitter/nvim-treesitter-textobjects",
    --     config = function()
    --         safeRequire("nvim-treesitter-textobjects", true, {
    --             textobjects = {
    --                 swap = {
    --                     enable = true,
    --                     swap_next = {
    --                         ["<leader>a"] = "@parameter.inner",
    --                     },
    --                     swap_previous = {
    --                         ["<leader>A"] = "@parameter.inner",
    --                     },
    --                 },
    --             },
    --         })
    --     end
    -- },

    -- Easy comments
    {
        "numToStr/Comment.nvim",
        config = function()
            safeRequire("Comment", true)
        end
    },

    -- Comment properly in embedded filetypes (Ejs, etc)
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
            safeRequire("ts_context_commentstring", true, {
                enable_autocmd = false,
            })
        end
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
        config = function()
            safeRequire("hover", true, {
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
            })

            -- Setup keymaps
            vim.keymap.set("n", "K", require("hover").hover, {desc = "hover.nvim"})
            vim.keymap.set("n", "gK", require("hover").hover_select, {desc = "hover.nvim (select)"})
        end
    },
    "nvim-lua/popup.nvim",
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        config = function()
            safeRequire("telescope", true, {
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
            })
            vim.api.nvim_set_keymap("n", "<leader>fb", ":Telescope buffers<CR>",                                 {noremap = true})
            vim.api.nvim_set_keymap("n", "<leader>fc", ":Telescope resume<CR>",                                  {noremap = true})
            vim.api.nvim_set_keymap("n", "<leader>ff", ":Telescope find_files<CR>",                              {noremap = true})
            vim.api.nvim_set_keymap("n", "<leader>fg", ":Telescope live_grep<CR>",                               {noremap = true})
            vim.api.nvim_set_keymap("n", "<leader>fh", ":Telescope help_tags<CR>",                               {noremap = true})
            vim.api.nvim_set_keymap("n", "<leader>fr", ":Telescope registers<CR>",                               {noremap = true})
            vim.api.nvim_set_keymap("n", "<leader>fm", ":Telescope marks<CR>",                                   {noremap = true})
            vim.api.nvim_set_keymap("n", "<leader>fs", ":Telescope search_history<CR>",                          {noremap = true})
        end
    },

    -- AI Autocomplete stuffs
    {
        "monkoose/neocodeium",
        event = "VeryLazy",
        -- Only enable if the machine has more than 8GB of RAM available
        enabled = vim.loop.get_total_memory() > 2^33,
        config = function()
            local neocodeium = require("neocodeium")
            neocodeium.setup({
                debounce = true,
                silent = true,
            })
            vim.keymap.set("i", "<A-f>", neocodeium.accept)
        end,
    },

    -- Put errors in the locationlist (<leader>z to open)
    {
        "folke/trouble.nvim",
        event = "VeryLazy",
        dependencies = "kyazdani42/nvim-web-devicons",
        config = function()
            -- Trouble settings (Show the diagnostics quickfix window automatically)
            vim.api.nvim_set_keymap("n", "<leader>z", "<cmd>Trouble diagnostics toggle<CR>", {silent = true, noremap = true})
            safeRequire("trouble", true, {
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
            })
        end
    },

    -- Git stuff
    "tpope/vim-fugitive",
    "sindrets/diffview.nvim",

    -- Git changes in the signcolumn
    {
        "lewis6991/gitsigns.nvim" ,
        config = function()
            safeRequire("gitsigns", true, {
                signs = {
                    -- Update these two from over/underscore so they'll actually show up
                    delete       = { text = '│' },
                    topdelete    = { text = '│' },
                },
            })
        end
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
        config = function()
            vim.api.nvim_set_keymap("n", "<F11>", "<cmd>AerialToggle<cr>", {noremap = true, silent = true})
            vim.api.nvim_set_keymap("x", "<F11>", "<cmd>AerialToggle<cr>", {noremap = true, silent = true})

            safeRequire("aerial", true, {
                layout = {
                    min_width = 30
                }
            })
        end
    },

    -- Nvim file explorer/ tree
    {
        "kyazdani42/nvim-tree.lua",
        dependencies = "kyazdani42/nvim-web-devicons",
        -- tag = "nightly",
        event = "VeryLazy",
        config = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            -- Set F12 to toggle the tree's pane
            vim.api.nvim_set_keymap("n", "<F12>", "<cmd>NvimTreeToggle<cr>", {noremap = true, silent = true})
            vim.api.nvim_set_keymap("x", "<F12>", "<cmd>NvimTreeToggle<cr>", {noremap = true, silent = true})

            -- Function to open to nvim-tree if we open nvim into a dir.
            -- Via https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup#open-for-directories-and-change-neovims-directory
            local function open_nvim_tree(data)
                local directory = vim.fn.isdirectory(data.file) == 1
                if not directory then
                    return
                end
                vim.cmd.cd(data.file)
                require("nvim-tree.api").tree.open()
            end
            vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

            safeRequire("nvim-tree", true, {
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
                }
            })
        end
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = "kyazdani42/nvim-web-devicons",
        config = function()
            safeRequire("lualine", true, {
                options = {
                    icons = true,
                    icons_enabled = true,
                    theme = "gruvbox_dark",
                },
                extensions = {
                    "fugitive",
                    "nvim-tree",
                    "quickfix"
                },
                sections = {
                    lualine_b = {
                        "branch",
                        "diff",
                        {
                            "diagnostics",
                            symbols = {
                                error = constants.diagnostic.sign.error,
                                warn  = constants.diagnostic.sign.warn,
                                info  = constants.diagnostic.sign.info,
                                hint  = constants.diagnostic.sign.hint
                            },
                        }
                    }
                }
            })
        end
    },
})


