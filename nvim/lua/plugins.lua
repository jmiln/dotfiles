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
        config = function()
            safeRequire("colorizer", true)
        end
    },

    -- Rainbow parens
    "HiPhish/rainbow-delimiters.nvim",

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
                context_commentstring = {
                    enable = true
                },
                ensure_installed = {
                    "comment",      -- Lets it highlight the TODO comments and such
                    "css",
                    "html",
                    "javascript",
                    "json",
                    "lua",          -- For the nvim config files
                    "regex",        -- Ooh, shiny regex
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

    -- Easy completion & expansion of strings for html
    {
        "mattn/emmet-vim",
        ft = {"html", "ejs", "css", "scss", "jsx", "tsx"}
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
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            safeRequire("nvim-surround", true)
        end
    },

    -- Easy comments
    {
        "numToStr/Comment.nvim",
        config = function()
            safeRequire("Comment", true)
        end
    },

    -- Comment properly in embedded filetypes (Ejs, etc)
    "JoosepAlviste/nvim-ts-context-commentstring",

    -- LSP stuffs
    "neovim/nvim-lspconfig",
    "nvim-lua/plenary.nvim",
    "nvim-lua/popup.nvim",
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {"nvim-lua/plenary.nvim"},
        config = function()
            vim.api.nvim_set_keymap("n", "<leader>fb", ":Telescope buffers<CR>",                                 { noremap = true})
            vim.api.nvim_set_keymap("n", "<leader>fc", ":Telescope resume<CR>",                                  { noremap = true})
            vim.api.nvim_set_keymap("n", "<leader>fd", ":lua require('config.telescope').search_dotfiles()<CR>", { noremap = true})
            vim.api.nvim_set_keymap("n", "<leader>ff", ":Telescope find_files<CR>",                              { noremap = true})
            vim.api.nvim_set_keymap("n", "<leader>fg", ":Telescope live_grep<CR>",                               { noremap = true})
            vim.api.nvim_set_keymap("n", "<leader>fh", ":Telescope help_tags<CR>",                               { noremap = true})
            vim.api.nvim_set_keymap("n", "<leader>fr", ":Telescope registers<CR>",                               { noremap = true})
            vim.api.nvim_set_keymap("n", "<leader>fs", ":Telescope search_history<CR>",                          { noremap = true})
        end
    },

    -- Notifications
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

    -- Open up the locationlist when there are errors
    {
        "folke/trouble.nvim",
        dependencies = "kyazdani42/nvim-web-devicons",
        config = function()
            -- Trouble settings (Show the diagnostics quickfix window automatically)
            vim.api.nvim_set_keymap("n", "<leader>z", "<cmd>TroubleToggle<CR>", {silent = true, noremap = true})
            safeRequire("trouble", true, {
                -- auto_open   = true,
                -- auto_close  = true,
                signs = {
                    -- icons / text used for a diagnostic
                    error       = "[ERROR]",
                    warning     = "[WARN]",
                    hint        = "[HINT]",
                    information = "[INFO]",
                    other       = "[OTHER]"
                },
            })
        end
    },

    -- Git stuff
    "tpope/vim-fugitive",

    -- Git changes in the signcolumn
    {
        "lewis6991/gitsigns.nvim" ,
        config = function()
            safeRequire("gitsigns", true)
        end
    },

    -- Uses vim splits to display more info when committing to git
    "rhysd/committia.vim",

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
        tag = "nightly",
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
                            corner = "└",
                            edge = "│",
                            item = "├",
                            none = " ",
                        },
                    },
                }
            })
        end
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = "kyazdani42/nvim-web-devicons",
        config = function()
            safeRequire("lualine", true, {
                options = {
                    component_separators = "",
                    icons = true,
                    icons_enabled = true,
                    theme = "gruvbox_dark",
                },
                extensions = {
                    "fugitive",
                    "nvim-tree",
                    "quickfix"
                }
            })
        end
    },

    -- Shut up the diagnostics while I'm in insert mode
    -- The main file is copied into ./config/dd.lua, and called in ./config/init.lua, since this doesn't seem to work
    -- Darn you Packer...
    -- use ({
    --     "https://gitlab.com/yorickpeterse/nvim-dd.git",
    --     as = "dd",
    --     config = function()
    --         require("dd").setup()
    --     end
    -- })
})


