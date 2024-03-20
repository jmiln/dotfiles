local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local lsOk,  luasnip = pcall(require, "luasnip")
local cmpOk, cmp     = pcall(require, "cmp")
local lspOk, lspkind = pcall(require, "lspkind")

-- Make sure they're all available & working before trying to configure em
if not lsOk or not cmpOk or not lspOk then
    return
end

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
    completion = {
        autocomplete = {
            cmp.TriggerEvent.InsertEnter,
            cmp.TriggerEvent.TextChanged,
        },
        completeopt = "menu,menuone,noselect",
        keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
        keyword_length = 1,
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = {
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<C-Space>"] = cmp.mapping.complete({
            config = {
                sources = {
                    { name = "luasnip" }
                }
            }
        }),
        ["<C-E>"]     = cmp.mapping.close(),
        ["<CR>"]      = cmp.mapping.confirm({
            behavior  = cmp.ConfirmBehavior.Insert,
            select    = true,
        })
    },
    sources = {
        { name = "codeium" },
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        { name = "luasnip" },
    },
    confirmation = {
        default_behavior = cmp.ConfirmBehavior.Insert,
    },
    formatting = {
        format = lspkind.cmp_format(
            {
                mode = "symbol_text",
                maxwidth = 50,
                ellipsis_char = '...',
                menu = ({
                    buffer   = "[Buff]",
                    nvim_lsp = "[LSP]",
                    path     = "[Path]",
                    luasnip  = "[Snip]",
                    codeium  = "[  ]",
                })
            }
        )
    }
})

local snip = luasnip.snippet
local node = luasnip.snippet_node
local text = luasnip.text_node
local insert = luasnip.insert_node

-- Add snippets for JS files
luasnip.add_snippets("javascript", {
    -- Javascript helpers
    snip( "reqins", { text('const { inspect } = require("util");') }),
    snip( "inspectdepth", { text("inspect("), insert(1), text(", {depth: 5});")}),   -- Insert `inspect(|, {depth: 5})`, with the cursor at |

    -- ESLint helpers
    snip( "nounused", { text("// eslint-disable-line no-unused-vars") }),
    snip( "noundef",  { text("// eslint-disable-line no-undef") }),
})

-- Add stuff for any file type (Replacing abbreviations)
luasnip.add_snippets("all", {
    -- Various useful symbols
    snip( "checkmark", { text("✓") })
})

