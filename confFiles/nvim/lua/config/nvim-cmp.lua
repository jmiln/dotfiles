local cmp = require("cmp")
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
    mapping = {
        ["<Tab>"] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end,
        ["<S-Tab>"] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end,
        ["<C-Space>"] = cmp.mapping.complete({
            config = {
                sources = {
                    { name = 'vsnip' }
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
        { name = "nvim_lsp" },
        -- { name = "buffer" },
        { name = "path" },
        { name = "vsnip" },
    },
    confirmation = {
        default_behavior = cmp.ConfirmBehavior.Insert,
    },
    formatting = {
        format = function(entry, vim_item)
            vim_item.menu = ({
                buffer   = "[Buffer]",
                nvim_lsp = "[LSP]",
                path     = "[Path]",
                vsnip    = "[VSnip]"
            })[entry.source.name]
            return vim_item
        end,
    }
})
