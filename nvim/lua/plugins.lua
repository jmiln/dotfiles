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

require("packer").init({
    max_jobs = 50,
})

return require('packer').startup(function(use)
    -- Let Packer manage itself
    use({"wbthomason/packer.nvim", opt = true})

    use "alvan/vim-closetag"
    use "farmergreg/vim-lastplace"
    use "junegunn/vim-easy-align"
    use "Konfekt/FastFold"
    use ({
        "mattn/emmet-vim",
        ft = {"html", "ejs", "css", "scss"}
    })

    -- Color any #ffffff style color codes
    use ({
        "norcalli/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup()
        end
    })

    use({
        "nvim-treesitter/nvim-treesitter",
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
        config = function()
            require("nvim-treesitter.configs").setup({
                highlight = {
                    enable = true
                },
                indent = {
                    enable = true
                },
                ensure_installed = {
                    "javascript",
                    "typescript",
                    "html",
                    "css",
                    "lua",          -- For the nvim config files
                    "comment"       -- Lets it highlight the TODO comments and such
                }
            })
        end,
    })
    -- use "nvim-treesitter/playground"

    -- Auto-close parentheses and brackets, etc
    use ({
        "steelsojka/pears.nvim",
        config = function()
            local R = require "pears.rule"
            require("pears").setup(function(conf)
                conf.pair("<", ">")
                conf.pair("(", {
                    close = ")",
                    should_expand = R.all_of(
                        -- Don't expand a quote if it comes before an alpha character
                        R.not_(R.match_next "[a-zA-Z]")
                    )
                })
            end)
        end
    })

    -- Quick changes for surrounding symbols (Quotes, parens, etc)
    use({
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup()
        end
    })


    -- Uses vim splits to display more info when committing to git
    use "rhysd/committia.vim"

    -- Easy comments
    use({
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    })

    -- LSP stuffs
    use "neovim/nvim-lspconfig"
    use ({
        "nvim-lua/plenary.nvim",
        config = function()
            require("plenary")
        end
    })
    use "nvim-lua/popup.nvim"
    use "nvim-telescope/telescope.nvim"

    -- Open up the locationlist when there are errors
    use({
        "folke/trouble.nvim",
        config = function()
            -- Trouble settings (Show the diagnostics quickfix window automatically)
            require("trouble").setup({
                -- fold_open   = "v",
                -- fold_closed = ">",
                auto_open   = true,
                auto_close  = true,
                icons       = false,
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


    -- Git stuff
    use "tpope/vim-fugitive"

    -- Git changes in the signcolumn
    use ({
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end
    })


    -- Autocomplete
    use({
        "hrsh7th/nvim-cmp",
        -- Sources for nvim-cmp
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            require('config.completion')
        end
    })

    -- Nvim nvim-tree
    use "kyazdani42/nvim-tree.lua"

    -- Statusline
    use "nvim-lualine/lualine.nvim"

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

    use ({
        "lewis6991/impatient.nvim",
        config = function()
            require("impatient")
        end
    })
end)
