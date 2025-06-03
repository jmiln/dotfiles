-- Use the default vim colorscheme, then edit from there
vim.cmd[[colorscheme vim]]

vim.cmd[[set t_Co=256]]
vim.cmd[[set termguicolors]]

local nvim_set_hl = vim.api.nvim_set_hl
local colors = {
    background = "#1C1C1C",

    -- Greys
    grey = "#5F5F5F",
    darkgrey = "#3A3A3A",
    darkergrey = "#292828",

    -- Reds
    lightred = "#ED3F32",

    -- Blues
    skyblue = "#74b4ed",
}

-- Setting the color for Normal seems to control the background color
nvim_set_hl(0, "Normal",               {bg=colors.background})
nvim_set_hl(0, "NormalFloat",          {bg=colors.darkergrey})
nvim_set_hl(0, "Visual",               {fg="white",      bg=colors.grey})
nvim_set_hl(0, "Constant",             {fg="lightgrey",  bg="none"})
nvim_set_hl(0, "Folded",               {fg="white",      bg=colors.grey})
nvim_set_hl(0, "FoldColumn",           {fg=colors.grey,  bg="none"})
nvim_set_hl(0, "Search",               {fg="black",      bg=colors.grey})
nvim_set_hl(0, "MatchParen",           {fg="black",      bg="white"})
nvim_set_hl(0, "Identifier",           {fg="grey"})
nvim_set_hl(0, "Statement",            {fg="green4"})
nvim_set_hl(0, "Title",                {fg="lightgrey",  bg="none"})
nvim_set_hl(0, "@text",                {fg="lightgrey",  bg="none"})
nvim_set_hl(0, "Type",                 {fg="green3"})
nvim_set_hl(0, "@lsp.mod.declaration", {fg=colors.skyblue})
nvim_set_hl(0, "@lsp.type.variable",   {fg="grey"})
nvim_set_hl(0, "@text.warning",        {fg="background", bg="yellow"})
nvim_set_hl(0, "@text.danger",         {fg="background", bg="red"})
nvim_set_hl(0, "@text.note",           {fg="gold",       bg="background"})
nvim_set_hl(0, "Conceal",              {fg="background", bg="grey"})

-- Diagnostic colors
nvim_set_hl(0, "DiagnosticError",      {fg=colors.lightred})
nvim_set_hl(0, "DiagnosticWarn",       {fg="orange"})
nvim_set_hl(0, "DiagnosticInfo",       {fg="gold"})
nvim_set_hl(0, "Error",                {link="DiagnosticError"})

-- Lualine colors
nvim_set_hl(0, "LualineDiffAdd",    {fg="green", bg="background"})
nvim_set_hl(0, "LualineDiffChange", {link="DiagnosticWarn"})
nvim_set_hl(0, "LualineDiffDelete", {link="DiagnosticError"})

-- Comments
-- Apparently need both for it to be consistent
nvim_set_hl(0, "Comment",         {fg="green",    bg="background"})
nvim_set_hl(0, "@comment",        {fg="green",    bg="background"})

-- Completion Menu
nvim_set_hl(0, "Pmenu",           {fg="background", bg="grey"})
nvim_set_hl(0, "PmenuSel",        {fg="Black",      bg="darkgrey"})

-- Line numbers
nvim_set_hl(0, "LineNr",          {fg=colors.grey,    bg="none"})
nvim_set_hl(0, "SignColumn",      {fg=colors.grey,    bg="none"})

-- Removes all styling for cursorline, but highlights the current line number
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
nvim_set_hl(0, "CursorLine", {})
nvim_set_hl(0, "CursorLineNR", {fg="orange",  bg="none"})

-- Git diff coloring
nvim_set_hl(0, "DiffAdded",   { fg="green", bg="none" })
nvim_set_hl(0, "DiffChanged", {link="DiagnosticWarn"})
nvim_set_hl(0, "DiffText",    { fg="black",  bg="green"   })
nvim_set_hl(0, "DiffRemoved", {link="DiagnosticError"})
