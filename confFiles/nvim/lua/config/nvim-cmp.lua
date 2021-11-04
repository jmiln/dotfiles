local cmp = require'cmp'
cmp.setup{
    completion = {
        autocomplete = {
            cmp.TriggerEvent.InsertEnter,
            cmp.TriggerEvent.TextChanged,
        },
        completeopt = 'menu,menuone,noselect',
        keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
        keyword_length = 1,
    },
    mapping = {
        ['<S-Tab>']   = cmp.mapping.select_prev_item(),
        ['<Tab>']     = cmp.mapping.select_next_item(),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-E>']     = cmp.mapping.close(),
        ['<CR>']      = cmp.mapping.confirm({
            behavior  = cmp.ConfirmBehavior.Insert,
            select    = true,
        })
    },
    sources = {
        { name = 'buffer' },
        { name = 'path' },
        -- { name = 'nvim_lsp' }
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
            })[entry.source.name]
            return vim_item
        end,
    }
}
