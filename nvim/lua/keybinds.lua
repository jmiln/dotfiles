-- Keybinds/ keymapping
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Set f to toggle paste mode
vim.o.pastetoggle="off"
vim.o.pastetoggle="<F6>"

local map = vim.api.nvim_set_keymap
local default = {noremap = true, silent = true}

map("n", "r",          "<C-R>",              default) -- Redo
map("n", "Y",          "yy",                 default) -- Y grabs whole line
map("n", "<Space>",    ":nohl<CR>",          default) -- Space to remove search highlights
map("n", "<Leader>ev", ":vsp $MYVIMRC<CR>",  default) -- Open the vimrc/ init.vim in a vertical split
map("n", "<Leader>sv", ":RefreshConfig<CR>", default) -- Open the vimrc/ init.vim in a vertical split
map("n", "<Leader>=",  "gg=G",               default) -- Indent whole file

-- Underline the current line with various symbols (such that the number of
-- underline matches line length and indendation)
map("n", "<Leader>-", "yypVr-", default)
map("n", '<Leader>"', 'yypVr"', default)

-- Paste over selected text without replacing what's being pasted in the register
map("v", "<leader>p", '"_dP', default)

-- Delete the selected text without saving it to a register
map("v", "<leader>d", '"_d', default)

-- EasyAlign mappings
map("x", "ga", ":EasyAlign<CR>", default)
map("n", "ga", ":EasyAlign<CR>", default)

-- A fancy unicode underline (Goes underneath whatever line you're on
map("n", "<leader>U", "yypVr━", default)

-- Keep search results centered
map("n", "n", "nzzzv", default);
map("n", "N", "Nzzzv", default);
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

-- Undotree
map("n", "<F5>", ":UndotreeToggle<CR>", default);

-- TAB/ Up & Down arrows to use the completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<C-h>"', {noremap = true, expr = true})
map('i', '<Tab>',   'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {noremap = true, expr = true})
map('i', '<Up>',    'pumvisible() ? "\\<C-p>" : "\\<Up>"',  {noremap = true, expr = true})
map('i', '<Down>',  'pumvisible() ? "\\<C-n>" : "\\<Down>"',{noremap = true, expr = true})

-- Let the arrow keys work in the command completion menu
map('c', '<Up>',    'wildmenumode() ? "\\<C-p>" : "\\<Up>"',  {noremap = true, expr = true})
map('c', '<Down>',  'wildmenumode() ? "\\<C-n>" : "\\<Down>"',{noremap = true, expr = true})

-- Map ctrl+/ to comment lines
map("n", "", "<Plug>(comment_toggle_linewise_current)",        {noremap = true, silent=true})
map("v", "", "<Plug>(comment_toggle_linewise_visual)",         {noremap = true, silent=true})
map("i", "", "<ESC><Plug>(comment_toggle_linewise_current)i",  {noremap = true, silent=true})

-- Telescope Mappings
map("n", "<leader>fb", ":Telescope buffers<CR>",                                 { noremap = true})
map("n", "<leader>fc", ":Telescope resume<CR>",                                  { noremap = true})
map("n", "<leader>fd", ":lua require('config.telescope').search_dotfiles()<CR>", { noremap = true})
map("n", "<leader>ff", ":Telescope find_files<CR>",                              { noremap = true})
map("n", "<leader>fg", ":Telescope live_grep<CR>",                               { noremap = true})
map("n", "<leader>fh", ":Telescope help_tags<CR>",                               { noremap = true})
map("n", "<leader>fr", ":Telescope registers<CR>",                               { noremap = true})
map("n", "<leader>fs", ":Telescope search_history<CR>",                          { noremap = true})


-- LSP mappings
-- Go to where the variable is defined
map("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", default)
-- Code action options
map("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", default)
-- Global (inside file) rename/ refactor
map("n", "<leader>gr", "<cmd>lua vim.lsp.buf.rename()<CR>", default)
-- Show info on element under cursor
map("n", "<leader>ho", "<cmd>lua vim.lsp.buf.hover()<CR>", default)


-- LSP bindings to jump between issues
map("n", "<c-j>", ":lua vim.diagnostic.goto_next()<CR>", default)
map("n", "<c-k>", ":lua vim.diagnostic.goto_prev()<CR>", default)


-- Refresh the config in the current file (Nice, but doesn't work on split up files)
-- vim.api.nvim_command("command! RefreshConfig source $MYVIMRC <bar> echo");


-- Run currently selected JS (Cool, but never used)
-- vim.api.nvim_command("command! -range RunNode <line1>,<line2>w !node");


-- Legacy Abbreviations
-- Typos
vim.api.nvim_command("cnoreabbrev Q q")
vim.api.nvim_command("cnoreabbrev W w")


