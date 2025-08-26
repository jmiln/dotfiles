local capabilities = require("blink.cmp").get_lsp_capabilities()
local constants = require("config.constants")
local icons = require("config.icons")

vim.diagnostic.config({
    float = {
        border = constants.ui.border,
        source = "if_many",
    },
    jump = {float = true},
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error .. " ",
            [vim.diagnostic.severity.WARN]  = icons.diagnostics.BoldWarn  .. " ",
            [vim.diagnostic.severity.INFO]  = icons.diagnostics.BoldInfo  .. " ",
            [vim.diagnostic.severity.HINT]  = icons.diagnostics.Hint  .. " ",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticError",
            [vim.diagnostic.severity.WARN]  = "DiagnosticWarn",
            [vim.diagnostic.severity.INFO]  = "DiagnosticInfo",
            [vim.diagnostic.severity.HINT]  = "DiagnosticHint",
        },
    },
    underline = { severity = vim.diagnostic.severity.WARN },
    update_in_insert = false,
    virtual_text = false,
    -- virtual_lines = {    -- These are nice, but oh boy, are they distracting
    --     severity = {
    --         min = vim.diagnostic.severity.ERROR,
    --     },
    -- },
})

vim.lsp.config("*", {
    capabilities = capabilities
})

return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "williamboman/mason.nvim",
                init = function()
                    -- Make mason packages available before loading it; allows to lazy-load mason.
                    vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
                    -- Do not crowd home directory with NPM cache folder
                    vim.env.npm_config_cache = vim.env.HOME .. "/.cache/npm"
                end,
                build = ":MasonUpdate",
                opts = {
                    ui = {
                        icons = {
                            package_installed = "✓",
                            package_pending = "➜",
                            package_uninstalled = "✗"
                        },
                    }
                }
            },
            {"WhoIsSethDaniel/mason-tool-installer.nvim"},
            {"williamboman/mason-lspconfig.nvim"},
        },
        lazy = false,
        config = function()
            require("mason").setup({
                ensure_installed = {
                    "stylua"
                }
            })
            require("mason-lspconfig").setup({
                automatic_enable = true,
                ensure_installed = {
                    "biome",    -- JS / TS Linting, formatting, etc
                    "cssls",    -- CSS
                    "emmet_language_server",  -- Emmet (html shortcuts)
                    "html",     -- HTML (duh)
                    "jsonls",   -- JSON
                    "lua_ls",   -- Lua language server
                    "ts_ls",    -- JS / TS
                }
            })
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "stylua",   -- Lua formatter
                }
            })
        end
    },

    -- Code actions / Diagnostic display (Looks cool, the diff is really nice, but it's a bit slower without the easy hotkeys that I can get to work)
    -- {
    --     "rachartier/tiny-code-action.nvim",
    --     dependencies = {
    --         {"nvim-lua/plenary.nvim"},
    --         {"nvim-telescope/telescope.nvim"},
    --     },
    --     event = "LspAttach",
    --     opts = {
    --         picker = "telescope",
    --         opts = {
    --             auto_preview = true,
    --             hotkeys = true,
    --             hotkeys_mode = "sequential",
    --             custom_keys = {
    --                 { key = "r", pattern = "Rename.*" }, -- Lua pattern matching
    --                 { key = "o", pattern = "Organize Imports.*" }, -- Lua pattern matching
    --             },
    --         }
    --     },
    --     init = function()
    --         vim.keymap.set("n", "<leader>ca", function()
    --             require("tiny-code-action").code_action()
    --         end, { noremap = true, silent = true })
    --     end
    -- },
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy", -- Or `LspAttach`
        priority = 1000, -- needs to be loaded in first
        config = function()
            require('tiny-inline-diagnostic').setup()
            vim.diagnostic.config({ virtual_text = false })
        end
    },

    {
        -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
        -- used for completion, annotations and signatures of Neovim apis
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
}

