local constants = require("config.constants")
local icons = require("config.icons")
local severity_names = {
    [vim.diagnostic.severity.ERROR] = "Error",
    [vim.diagnostic.severity.WARN] = "Warn",
    [vim.diagnostic.severity.INFO] = "Info",
    [vim.diagnostic.severity.HINT] = "Hint",
}

vim.diagnostic.config({
    float = {
        border = constants.ui.border,
        source = "if_many",
        prefix = function(diag)
            local level = severity_names[diag.severity]
            local prefix = "▍" .. string.format(" %s [%s] ", icons.diagnostics[level], diag.code)
            return prefix, "Diagnostic" .. level:gsub("^%l", string.upper)
        end,
        suffix = "",
    },
    jump = { float = true },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error .. " ",
            [vim.diagnostic.severity.WARN] = icons.diagnostics.BoldWarn .. " ",
            [vim.diagnostic.severity.INFO] = icons.diagnostics.BoldInfo .. " ",
            [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint .. " ",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticError",
            [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticHint",
        },
    },
    underline = { severity = vim.diagnostic.severity.WARN },
    update_in_insert = false,
    virtual_text = {
        severity = {
            vim.diagnostic.severity.WARN,
            vim.diagnostic.severity.ERROR,
        },
        spacing = 2,
        format = function(diagnostic)
            -- Use shorter, nicer names for some sources:
            local special_sources = {
                ["Lua Diagnostics."] = "lua",
                ["Lua Syntax Check."] = "lua",
            }

            local message = ""
            if diagnostic.code then
                message = string.format("%s %s", message, diagnostic.code)
            end
            if diagnostic.source then
                message = string.format("%s[%s]", message, special_sources[diagnostic.source] or diagnostic.source)
            end
            if message == "" then
                message = diagnostic.message
            end

            return message .. " "
        end,
    },
    -- virtual_lines = {    -- These are nice, but oh boy, are they distracting
    --     severity = {
    --         min = vim.diagnostic.severity.ERROR,
    --     },
    -- },
})

-- vim.lsp.config("tsgo", {
--     cmd = { "tsgo", "--lsp", "--stdio" },
--     filetypes = {
--         "ts",
--     },
--     root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
-- })

-- Doesn't work, but would be nice
-- vim.api.nvim_create_autocmd("BufEnter", {
--     desc = "Disable diagnostics for test files",
--     pattern = { "*.test.js" },
--     callback = function()
--         vim.diagnostic.enable(false)
--     end,
-- })

return {
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            {
                "neovim/nvim-lspconfig",
            },
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
                            package_uninstalled = "✗",
                        },
                    },
                },
            },
            {
                "WhoIsSethDaniel/mason-tool-installer.nvim",
                opts = {
                    ensure_installed = {
                        "dotenv-linter",    -- .env linter
                        "shellcheck",       -- Shell linter
                        "shfmt",            -- Shell formatter
                        "stylua",           -- Lua formatter
                        "jq",               -- JSON formatting
                    },
                }
            },
        },
        opts = {
            automatic_enable = true,
            ensure_installed = {
                "biome",                 -- JS / TS Linting, formatting, etc
                "cssls",                 -- CSS
                "emmet_language_server", -- Emmet (html shortcuts)
                "html",                  -- HTML (duh)
                "jsonls",                -- JSON
                -- "lua_ls",             -- Lua language server
                "emmylua_ls",            -- Lua language server (Faster?)
                "taplo",                 -- *.toml formatting/ lsp
                -- "ts_ls",                 -- JS / TS
                -- "tsgo",                  -- JS / TS (Way faster in .ts files, but breaks in .js files, and can't filter the errors)
            },
        }
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
    -- { -- These are really nice looking, but they also show in front of other text sometimes and get in the way
    --     "rachartier/tiny-inline-diagnostic.nvim",
    --     event = "VeryLazy", -- Or `LspAttach`
    --     priority = 1000, -- needs to be loaded in first
    --     config = function()
    --         require('tiny-inline-diagnostic').setup()
    --         vim.diagnostic.config({ virtual_text = false })
    --     end
    -- },

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

    -- Show TS errors more cleanly?
    {
        "davidosomething/format-ts-errors.nvim",
    },

    -- Make ts errors easier to read?
    -- {
    --     "dmmulroy/ts-error-translator.nvim",
    --     config = function()
    --         require("ts-error-translator").setup({
    --         auto_attach = true,
    --         servers = {
    --             "ts_ls",
    --         },
    --     })
    --     end,
    --     -- opts = {
    --     --     auto_attach = true,
    --     --     servers = {
    --     --         "ts_ls",
    --     --         "typescript-tools",
    --     --     },
    --     -- }
    -- },
}
