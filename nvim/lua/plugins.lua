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

function safeRequire(pName, doSetup, setupObj)
    setupObj = setupObj or {}
    local ok, module = pcall(require, pName)
    if not ok then
        vim.notify("Couldn't load plugin: '" .. pName .. "'")
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
    use({"wbthomason/packer.nvim", opt = true})

    -- Easily align stuff
    use "junegunn/vim-easy-align"

    -- Color any #ffffff style color codes
    use ({
        "norcalli/nvim-colorizer.lua",
        config = function()
            safeRequire("colorizer", true)
        end
    })

    -- Preview markdown in a floating window (:Glow)
    use ({
        "ellisonleao/glow.nvim",
        config = function()
            safeRequire("glow", true)
        end
    })

    -- Preview line jumps
    use({
        "nacro90/numb.nvim",
        config = function()
            safeRequire("numb", true)
        end,
    })

    use({
        "nvim-treesitter/nvim-treesitter",
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
        config = function()
            safeRequire("nvim-treesitter.configs", true, {
                highlight = {
                    enable = true
                },
                indent = {
                    enable = true
                },
                context_commentstring = {
                    enable = true
                },
                ensure_installed = {
                    "javascript",
                    "typescript",
                    "html",
                    "css",
                    "lua",          -- For the nvim config files
                    "comment",      -- Lets it highlight the TODO comments and such
                    "regex",        -- Ooh, shiny regex
                }
            })
        end,
    })
    use "nvim-treesitter/playground"

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

    -- Uses vim splits to display more info when committing to git
    use "rhysd/committia.vim"

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
    use "nvim-telescope/telescope.nvim"

    -- Open up the locationlist when there are errors
    use({
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            -- Trouble settings (Show the diagnostics quickfix window automatically)
            safeRequire("trouble", true, {
                auto_open   = true,
                auto_close  = true,
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
    use ({ "lewis6991/gitsigns.nvim" })

    use ({
        "L3MON4D3/LuaSnip",
        -- This commit is before the `normalize paths` commit happened, and made it error on every save
        commit = "faa525713e1244551877a4d89646a10f3c3fa31e"
    })

    use({
        "hrsh7th/nvim-cmp",
        -- Sources for nvim-cmp
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-cmdline",
            "onsails/lspkind-nvim",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            safeRequire("config.completion")
        end
    })

    -- Nvim nvim-tree
    use ({
        "kyazdani42/nvim-tree.lua",
        requires = "kyazdani42/nvim-web-devicons",
        tag = "nightly",
    })

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

    -- Make stuffs more efficient/ optimized
    use("nathom/filetype.nvim")
    use ({
        "lewis6991/impatient.nvim",
        config = function()
            safeRequire("impatient")
        end
    })
end)
