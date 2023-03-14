local execute = vim.api.nvim_command
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    execute("packadd packer.nvim")
end

-- Autocompile
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

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

local packStatus, packer = pcall(require, "packer")
if not packStatus then
    return
end

packer.init({
    max_jobs = 50,
    display = {
        open_fn = function()
            return require("packer.util").float({ border = "rounded" })
        end,
    },
})

return packer.startup(function(use)
    -- Let Packer manage itself
    use({"wbthomason/packer.nvim"})

    -- Easily align stuff
    -- use "junegunn/vim-easy-align"

    use {
        "echasnovski/mini.align",
        branch = "stable",
        config = function()
            safeRequire("mini.align", true)
        end
    }


    -- Color any #ffffff style color codes
    use ({
        "NvChad/nvim-colorizer.lua",
        config = function()
            safeRequire("colorizer", true)
        end
    })

    -- More in-depth undo
    use ({
        "mbbill/undotree",
        config = function()
            vim.api.nvim_set_keymap("n", "<F5>", ":UndotreeToggle<CR>", {noremap = true, silent = true});
        end
    })

    -- Preview markdown in a floating window (:Glow)
    use ({
        "ellisonleao/glow.nvim",
        config = function()
            safeRequire("glow", true, {
                width = 999,
                height = 999,
                width_ratio  = 0.8,
                height_ratio = 0.8,
            })
        end
    })

    use({
        "nvim-treesitter/nvim-treesitter",
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
        config = function()
            safeRequire("nvim-treesitter.configs", true, {
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false
                },
                indent = {
                    enable = false
                },
                context_commentstring = {
                    enable = true
                },
                ensure_installed = {
                    "comment",      -- Lets it highlight the TODO comments and such
                    "css",
                    "help",
                    "html",
                    "javascript",
                    "json",
                    "lua",          -- For the nvim config files
                    "regex",        -- Ooh, shiny regex
                    "typescript",
                }
            })
        end,
    })
    -- use "nvim-treesitter/playground"

    -- Plugin to allow join toggles & other features (Nifty, but gets in the way more often than not)
    -- use({
    --     "Wansmer/treesj",
    --     requires = { "nvim-treesitter" },
    --     config = function()
    --         vim.api.nvim_set_keymap("n", "<S-J>", ":TSJToggle<CR>", {noremap = true, silent = true})
    --         safeRequire("treesj", true, {
    --             use_default_keymaps = false,
    --         })
    --     end,
    -- })

    -- Add documentation comments (JSDoc style)
    -- use {
    --     "danymat/neogen",
    --     config = function()
    --         safeRequire("neogen", true)
    --     end,
    --     requires = "nvim-treesitter/nvim-treesitter",
    --     tag = "*"
    -- }

    -- Auto-close parentheses and brackets, etc
    use ({
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
    })

    -- Easy completion & expansion of strings for html
    use ({
        "mattn/emmet-vim",
        ft = {"html", "ejs", "css", "scss"}
    })

    -- Automatically change strings to `` for template literals (JS)
    use ({
        "axelvc/template-string.nvim",
        config = function()
            safeRequire("template-string", true)
        end
    })

    -- Auto-close html tags
    use ({
        "windwp/nvim-ts-autotag",
        ft = {"html", "ejs", "css", "scss"},
        config = function()
            safeRequire("nvim-ts-autotag", true)
        end
    })

    -- Quick changes for surrounding symbols (Quotes, parens, etc)
    use({
        "kylechui/nvim-surround",
        requires = {
            "nvim-treesitter/nvim-treesitter-textobjects",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            safeRequire("nvim-surround", true)
        end
    })

    -- Easy comments
    use({
        "numToStr/Comment.nvim",
        config = function()
            safeRequire("Comment", true)
        end
    })

    -- Comment properly in embedded filetypes (Ejs, etc)
    use "JoosepAlviste/nvim-ts-context-commentstring"

    -- LSP stuffs
    use "neovim/nvim-lspconfig"
    use ({
        "nvim-lua/plenary.nvim",
        config = function()
            safeRequire("plenary")
        end
    })
    use "nvim-lua/popup.nvim"
    use ({
        "nvim-telescope/telescope.nvim",
        requires = "nvim-lua/plenary.nvim",
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
    })

    -- Notifications
    use ({
        "rcarriga/nvim-notify",
        requires = "nvim-lua/plenary.nvim",
        config = function()
            local ok, notify = pcall(require, "notify")
            if not ok then
                return
            end
            vim.notify = notify
        end
    })

    -- Open up the locationlist when there are errors
    use({
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            -- Trouble settings (Show the diagnostics quickfix window automatically)
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
    })

    -- Plugin to supposedly list todo comments in a file, but never seemed to work
    -- PERF stes
    -- TODO test
    -- HACK tes
    -- NOTE test
    -- FIXME etst
    -- WARNING test
    -- MARK test
    -- use {
    --     "folke/todo-comments.nvim",
    --     requires = "nvim-lua/plenary.nvim",
    --     config = function()
    --         safeRequire("todo-comments", true, {
    --
    --         })
    --     end,
    -- }

    -- Git stuff
    use "tpope/vim-fugitive"

    -- Git changes in the signcolumn
    use ({
        "lewis6991/gitsigns.nvim" ,
        config = function()
            safeRequire("gitsigns", true)

            -- Setup the scrollbar integration
            local okGit, gitScroll = pcall(require, "scrollbar.handlers.gitsigns")
            if okGit then
                gitScroll.setup()
            end
        end
    })

    -- Uses vim splits to display more info when committing to git
    use "rhysd/committia.vim"

    -- use {'akinsho/git-conflict.nvim', tag = "*", config = function()
    --     safeRequire("git-conflict", true, {
    --         default_mappings = true, -- disable buffer local mapping created by this plugin
    --         disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
    --         highlights = { -- They must have background color, otherwise the default color will be used
    --             incoming = 'DiffText',
    --             current = 'DiffAdd',
    --         }
    --     })
    -- end}

    -- Snippets
    use ({
        "L3MON4D3/LuaSnip",
    })

    -- Scrollbar / shows where errors/ other marks are
    -- use({
    --     "petertriho/nvim-scrollbar",
    --     config = function()
    --         safeRequire("scrollbar", true)
    --     end
    -- })

    -- Completion menus
    use({
        "hrsh7th/nvim-cmp",
        -- Sources for nvim-cmp
        requires = {
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
        end
    })
    use {
        'stevearc/aerial.nvim',
        config = function()
            vim.api.nvim_set_keymap("n", "<F11>", "<cmd>AerialToggle<cr>", {noremap = true, silent = true})
            vim.api.nvim_set_keymap("x", "<F11>", "<cmd>AerialToggle<cr>", {noremap = true, silent = true})

            safeRequire("aerial", true, {
                layout = {
                    min_width = 30
                }
            })
        end
    }

    -- Nvim file explorer/ tree
    use ({
        "kyazdani42/nvim-tree.lua",
        requires = "kyazdani42/nvim-web-devicons",
        tag = "nightly",
        config = function()
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1

            -- Set F12 to toggle the tree's pane
            vim.api.nvim_set_keymap("n", "<F12>", "<cmd>NvimTreeToggle<cr>", {noremap = true, silent = true})
            vim.api.nvim_set_keymap("x", "<F12>", "<cmd>NvimTreeToggle<cr>", {noremap = true, silent = true})

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
    })

    -- Pops up the usage for whatever function you're using if available
    -- use {
    --     "ray-x/lsp_signature.nvim",
    --     config = function()
    --         safeRequire("lsp_signature", true)
    --     end
    -- }

    -- Statusline
    use {
        "nvim-lualine/lualine.nvim",
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
    }

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

    -- Make stuffs more efficient/ optimized
    -- use({
    --     "nathom/filetype.nvim",
    --     config = function()
    --         safeRequire("filetype", {
    --             overrides = {
    --                 extensions = {
    --                     ts = "typescript",
    --                     sh = "sh"
    --                 },
    --                 function_extensions = {
    --                     ["sh"] = function()
    --                         vim.bo.filetype = "sh"
    --                     end
    --                 },
    --                 shebang = {
    --                     bash = "sh"
    --                 }
    --             }
    --         })
    --         -- Do not source the default filetype.vim
    --         vim.g.did_load_filetypes = 1
    --     end
    -- })
    use ({
        "lewis6991/impatient.nvim",
        config = function()
            safeRequire("impatient")
        end
    })
end)


