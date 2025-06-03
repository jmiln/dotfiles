return {
    -- Preview markdown in a floating window (:Glow)
    { -- Not supported anymore, but my preferred option
        "ellisonleao/glow.nvim",
        opts = {
            width = 999,
            height = 999,
            width_ratio = 0.8,
            height_ratio = 0.8,
        },
    },
    -- {
    --     'MeanderingProgrammer/render-markdown.nvim',
    --     dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    --     opts = {
    --         enabled = false,
    --         completions = {
    --             blink = {
    --                 enabled = true,
    --             },
    --         },
    --     },
    -- },
}
