-- Use the default vim colorscheme, then edit from there
vim.cmd[[colorscheme vim]]

vim.cmd[[set t_Co=256]]
vim.cmd[[set termguicolors]]

local nvim_set_hl = vim.api.nvim_set_hl

nvim_set_hl(0, "Normal",               {bg="#1C1C1C"})
nvim_set_hl(0, "NormalFloat",          {bg="#292828"})
nvim_set_hl(0, "Visual",               {fg="white",      bg="#5f5f5f"})
nvim_set_hl(0, "Constant",             {fg="lightgrey",  bg="none"})
nvim_set_hl(0, "Error",                {fg="red",        bg="black"})
nvim_set_hl(0, "Folded",               {fg="white",      bg="#5f5f5f"})
nvim_set_hl(0, "FoldColumn",           {fg="#5F5F5F",    bg="#1C1C1C"})
nvim_set_hl(0, "Search",               {fg="black",      bg="#5f5f5f"})
nvim_set_hl(0, "MatchParen",           {fg="black",      bg="white"})
nvim_set_hl(0, "Identifier",           {fg="grey"})
nvim_set_hl(0, "Statement",            {fg="green4"})
nvim_set_hl(0, "Title",                {fg="lightgrey",  bg="none"})
nvim_set_hl(0, "@text",                {fg="lightgrey",  bg="none"})
nvim_set_hl(0, "Type",                 {fg="green3"})
nvim_set_hl(0, "DiagnosticError",      {fg="#ffa500"})
nvim_set_hl(0, "@lsp.mod.declaration", {fg="#74b4ed"}) -- Light blue
nvim_set_hl(0, "@lsp.type.variable",   {fg="grey"})
nvim_set_hl(0, "@text.warning",        {fg="background", bg="yellow"})
nvim_set_hl(0, "@text.danger",         {fg="background", bg="red"})
nvim_set_hl(0, "@text.note",           {fg="#ffa500",    bg="background"})
nvim_set_hl(0, "Conceal",              {fg="background", bg="grey"})

-- Comments
-- Apparently need both for it to be consistent
nvim_set_hl(0, "Comment",         {fg="#68792d",    bg="background"})
nvim_set_hl(0, "@comment",        {fg="#68792d",    bg="background"})

-- Completion Menu
nvim_set_hl(0, "Pmenu",           {fg="background", bg="grey"})
nvim_set_hl(0, "PmenuSel",        {fg="Black",      bg="darkgrey"})

-- Line numbers
nvim_set_hl(0, "LineNr",          {fg="#5F5F5F",    bg="#1C1C1C"})
nvim_set_hl(0, "SignColumn",      {fg="#5F5F5F",    bg="#1C1C1C"})

-- Removes all styling for cursorline
nvim_set_hl(0, "CursorLine", {})
nvim_set_hl(0, "CursorLineNR", {})

-- Git diff coloring
nvim_set_hl(0, "DiffAdded",   { fg="green", bg="#1C1C1C" })
nvim_set_hl(0, "DiffChanged", { fg="yellow", bg="#1C1C1C" })
nvim_set_hl(0, "DiffText",    { fg="black",  bg="green"   })
nvim_set_hl(0, "DiffRemoved", { fg="red",    bg="#1C1C1C" })

-- Gray
nvim_set_hl(0, "CmpItemAbbrDeprecated", { bg="NONE", strikethrough=true, fg="#808080" })

-- Light blue
nvim_set_hl(0, "CmpItemKindVariable",   { bg="NONE", fg="#9CDCFE" })
nvim_set_hl(0, "CmpItemKindInterface",  { link="CmpItemKindVariable" })
nvim_set_hl(0, "CmpItemKindText",       { link="CmpItemKindVariable" })
nvim_set_hl(0, "CmpItemAbbrMatch",      { link="CmpItemKindVariable" })
nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link="CmpItemKindVariable" })

-- Pink
nvim_set_hl(0, "CmpItemKindFunction",   { bg="NONE", fg="#C586C0" })
nvim_set_hl(0, "CmpItemKindMethod",     { link="CmpItemKindFunction" })

-- Front
nvim_set_hl(0, "CmpItemKindKeyword",    { bg="NONE", fg="#D4D4D4" })
nvim_set_hl(0, "CmpItemKindProperty",   { link="CmpItemKindKeyword" })
nvim_set_hl(0, "CmpItemKindUnit",       { link="CmpItemKindKeyword" })
nvim_set_hl(0, "CmpItemAbbrDefault",    { link="Pmenu" })
nvim_set_hl(0, "CmpItemMenuDefault",    { link="Pmenu" })
