-- Keybinds/ keymapping
vim.g.mapleader = ','
vim.g.maplocalleader = ','

-- Set f to toggle paste mode
vim.o.pastetoggle="off"
vim.o.pastetoggle="<F6>"

local map = vim.api.nvim_set_keymap
local default = {noremap = true, silent = true}

map("n", "r",       "<C-R>",    default) -- Redo
map("n", "Y",       "yy",        default) -- Y grabs whole line
map('n', '<Space>', ':nohl<CR>', default) -- Space to remove search highlights
map("n", "<Leader>ev", ":vsp $MYVIMRC<CR>", default) -- Open the vimrc/ init.vim in a vertical split
map("n", "<Leader>sv", ":RefreshConfig<CR>", default) -- Open the vimrc/ init.vim in a vertical split
map("n", "<Leader>=", "gg=G", default)  -- Indent whole file

-- Underline the current line with various symbols (such that the number of
-- underline matches line length and indendation)
map("n", "<Leader>-", "yypVr-", default)
map("n", '<Leader>"', 'yypVr"', default)

-- A fancy unicode underline
map("n", "<leader>U", "yypVr━", default)

-- Bubble lines
-- map("v", "<C-K>", ":m '<-2<CR>gv=gv", default)
-- map("v", "<C-J>", ":m '>+1<CR>gv=gv", default)

-- Local, then global replace (Wimpy refactor)
map("n", "gr", "gd[{V%:s/<C-R>///gc<left><left><left>", default)
map("n", "gR", "gD:%s/<C-R>///gc<left><left><left>",    default)

-- Surround a visual selection with the specified character
map("v", "'", "<esc>`>a'<esc>`<i'<esc>", default);
map("v", '"', '<esc>`>a"<esc>`<i"<esc>', default);
map("v", "(", "<esc>`>a)<esc>`<i(<esc>", default);
map("v", "[", "<esc>`>a]<esc>`<i[<esc>", default);
map("v", "{", "<esc>`>a}<esc>`<i{<esc>", default);

-- Keep search results centered
map("v", "n", "nzzzv", default);
map("v", "N", "Nzzzv", default);

-- Keep your selection when shifting
map("v", ">", ">gv", default);
map("v", "<", "<gv", default);

-- Put the cursor back where it was when joining lines
map("n", "J", "mzJ`z", default);

-- Extra undo break points
map("v", ",", ",<c-g>u", default);
map("v", ".", ".<c-g>u", default);
map("v", "!", "!<c-g>u", default);
map("v", "?", "?<c-g>u", default);

-- TAB/ Up & Down arrows to use the completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<C-h>"', {noremap = true, expr = true})
map('i', '<Tab>',   'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {noremap = true, expr = true})
map('i', '<Up>',    'pumvisible() ? "\\<C-p>" : "\\<Up>"',  {noremap = true, expr = true})
map('i', '<Down>',  'pumvisible() ? "\\<C-n>" : "\\<Down>"',{noremap = true, expr = true})

-- Let the arrow keys work in the command completion menu
map('c', '<Up>',    'wildmenumode() ? "\\<C-p>" : "\\<Up>"',  {noremap = true, expr = true})
map('c', '<Down>',  'wildmenumode() ? "\\<C-n>" : "\\<Down>"',{noremap = true, expr = true})

-- Map ctrl+/ to comment lines
map('n', '', ':CommentToggle<CR>',      {noremap = true, silent=true})
map('v', '', ':CommentToggle<CR>',      {noremap = true, silent=true})
map('i', '', '<esc>:CommentToggle<CR>', {noremap = true, silent=true})

-- Telescope Mappings
map('n', '<leader>ff', ':Telescope find_files<CR>', {noremap = true})
map('n', '<leader>fg', ':Telescope live_grep<CR>',  {noremap = true})
map('n', '<leader>fb', ':Telescope buffers<CR>',    {noremap = true})
map('n', '<leader>fh', ':Telescope help_tags<CR>',  {noremap = true})
map('n', '<leader>fd', ':lua require("config.telescope").search_dotfiles()<CR>',  {noremap = true})

-- LSP mappings
map("n", "<leader>dq", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", default)
map("n", "<c-]>", "<cmd>lua vim.lsp.buf.definition()<cr>", default)

-- LSP Lspsaga bindings
map("n", "<c-j>", ":Lspsaga diagnostic_jump_next<CR>", default)
map("n", "<c-k>", ":Lspsaga diagnostic_jump_prev<CR>", default)


-- Refresh the config in the current file
vim.api.nvim_command('command! RefreshConfig source $MYVIMRC <bar> echo');


-- Run currently selected JS
vim.api.nvim_command("command! -range RunNode <line1>,<line2>w !node");


-- Legacy Abbreviations
  -- Nodejs helpers
vim.api.nvim_command('ab reqins const {inspect} = require("util");')
vim.api.nvim_command('ab inspectdepth inspect(, {depth: 5})')
  -- ESLint helpers
vim.api.nvim_command('ab nounused // eslint-disable-line no-unused-vars')
vim.api.nvim_command('ab noundef  // eslint-disable-line no-undef')
  -- Discord.js / Bot stuff helpers
vim.api.nvim_command('ab mslang message.language.get()')
vim.api.nvim_command('ab inlang interaction.language.get()')
vim.api.nvim_command('ab embedsep "=============================="')
vim.api.nvim_command('ab slashac { name: "allycode", description: "The ally code of the user you want to see", type: "STRING" },')
  -- Various seperators
vim.api.nvim_command('abb dotlin ……………………………………………………………………………………………………………………………………………………………………………………………')
vim.api.nvim_command('abb cdotlin /*…………………………………………………………………………………………………………………………………………………………………………………*/')
vim.api.nvim_command('abb fdotlin •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••')
vim.api.nvim_command('abb cfdotlin /*•••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••*/')
vim.api.nvim_command('abb dlin =======================================================================')
vim.api.nvim_command('abb cdlin /*===================================================================*/')
vim.api.nvim_command('abb lin -----------------------------------------------------------------------')
vim.api.nvim_command('abb clin /*-------------------------------------------------------------------*/')
vim.api.nvim_command('abb ulin _______________________________________________________________________')
vim.api.nvim_command('abb culin /*___________________________________________________________________*/')
vim.api.nvim_command('abb Ulin ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯')
vim.api.nvim_command('abb cUlin /*¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/')
  -- Various useful symbols
vim.api.nvim_command('ab chkmrk ✓')
vim.api.nvim_command('ab checkmark ✓')
  -- Typos
vim.api.nvim_command('cnoreabbrev Q q')
vim.api.nvim_command('cnoreabbrev W w')


