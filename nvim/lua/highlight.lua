-- Use the default vim colorscheme, then edit from there
vim.cmd[[colorscheme vim]]

vim.cmd[[set t_Co=256]]
vim.cmd[[set termguicolors]]

vim.api.nvim_set_hl(0, "Normal",          {bg="#1C1C1C"})
vim.api.nvim_set_hl(0, "NormalFloat",     {bg="#292828"})
vim.api.nvim_set_hl(0, "Visual",          {fg="white",      bg="#5f5f5f"})
vim.api.nvim_set_hl(0, "Comment",         {fg="#68792d",    bg="background"})
vim.api.nvim_set_hl(0, "Constant",        {fg="lightgrey",  bg="none"})
vim.api.nvim_set_hl(0, "Error",           {fg="red",        bg="black"})
vim.api.nvim_set_hl(0, "Folded",          {fg="white",      bg="#5f5f5f"})
vim.api.nvim_set_hl(0, "FoldColumn",      {fg="#5F5F5F",    bg="#1C1C1C"})
vim.api.nvim_set_hl(0, "Search",          {fg="black",      bg="#5f5f5f"})
vim.api.nvim_set_hl(0, "MatchParen",      {fg="black",      bg="white"})
vim.api.nvim_set_hl(0, "Identifier",      {fg="grey"})
vim.api.nvim_set_hl(0, "LineNr",          {fg="#5F5F5F",    bg="#1C1C1C"})
vim.api.nvim_set_hl(0, "SignColumn",      {fg="#5F5F5F",    bg="#1C1C1C"})
vim.api.nvim_set_hl(0, "Statement",       {fg="green4"})
vim.api.nvim_set_hl(0, "Title",           {fg="lightgrey",  bg="none"})
vim.api.nvim_set_hl(0, "@text",           {fg="lightgrey",  bg="none"})
vim.api.nvim_set_hl(0, "Type",            {fg="green3"})
vim.api.nvim_set_hl(0, "DiagnosticError", {fg="#ffa500"})
vim.api.nvim_set_hl(0, "@comment",        {fg="#68792d",    bg="background"})
vim.api.nvim_set_hl(0, "@text.warning",   {fg="background", bg="yellow"})
vim.api.nvim_set_hl(0, "@text.danger",    {fg="background", bg="red"})
vim.api.nvim_set_hl(0, "@text.note",      {fg="#ffa500",    bg="background"})
vim.api.nvim_set_hl(0, "Conceal",         {fg="background", bg="grey"})
vim.api.nvim_set_hl(0, "Pmenu",           {fg="background", bg="grey"})
vim.api.nvim_set_hl(0, "PmenuSel",        {fg="Black",      bg="darkgrey"})

-- Removes all styling for cursorline
vim.api.nvim_set_hl(0, "CursorLine", {})
vim.api.nvim_set_hl(0, "CursorLineNR", {})

-- Git diff coloring
vim.api.nvim_set_hl(0, "DiffAdded",   { fg="green", bg="#1C1C1C" })
vim.api.nvim_set_hl(0, "DiffChanged", { fg="yellow", bg="#1C1C1C" })
vim.api.nvim_set_hl(0, "DiffText",    { fg="black",  bg="green"   })
vim.api.nvim_set_hl(0, "DiffRemoved", { fg="red",    bg="#1C1C1C" })

-- Gray
vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { bg="NONE", strikethrough=true, fg="#808080" })

-- Light blue
vim.api.nvim_set_hl(0, "CmpItemKindVariable",   { bg="NONE", fg="#9CDCFE" })
vim.api.nvim_set_hl(0, "CmpItemKindInterface",  { link="CmpItemKindVariable" })
vim.api.nvim_set_hl(0, "CmpItemKindText",       { link="CmpItemKindVariable" })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatch",      { link="CmpItemKindVariable" })
vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link="CmpItemKindVariable" })

-- Pink
vim.api.nvim_set_hl(0, "CmpItemKindFunction",   { bg="NONE", fg="#C586C0" })
vim.api.nvim_set_hl(0, "CmpItemKindMethod",     { link="CmpItemKindFunction" })

-- Front
vim.api.nvim_set_hl(0, "CmpItemKindKeyword",    { bg="NONE", fg="#D4D4D4" })
vim.api.nvim_set_hl(0, "CmpItemKindProperty",   { link="CmpItemKindKeyword" })
vim.api.nvim_set_hl(0, "CmpItemKindUnit",       { link="CmpItemKindKeyword" })
vim.api.nvim_set_hl(0, "CmpItemAbbrDefault",    { link="Pmenu" })
vim.api.nvim_set_hl(0, "CmpItemMenuDefault",    { link="Pmenu" })
