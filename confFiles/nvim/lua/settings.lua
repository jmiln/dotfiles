local cmd  = vim.cmd     		-- execute Vim commands
local exec = vim.api.nvim_exec 	-- execute Vimscript
local fn   = vim.fn       		-- call Vim functions
local g    = vim.g         		-- global variables
local opt  = vim.opt         	-- global/buffer/windows-scoped options

----------------------------- Tabs & Indentation ------------------------------
opt.cursorline  = false
opt.expandtab   = true		-- tabs insert spaces
opt.joinspaces  = false		-- only one space after punction when joining lines
opt.list        = false     -- show listchars
opt.listchars   = { extends = "›", precedes = "‹", nbsp = "·", tab = "→ ", trail = "·", eol = "¬" }
opt.autoindent = true
opt.smartindent = true		-- autoindent new lines
opt.smarttab    = true
opt.shiftwidth  = 4			-- shift 4 spaces when tab
opt.tabstop     = 4         -- 1 tab == 4 spaces
opt.softtabstop = 4         -- 1 tab == 4 spaces


---------------------------------- Searching ----------------------------------
opt.path:append {"**"} -- add current file location to path
opt.ignorecase    = true
opt.smartcase     = true
vim.opt.hlsearch  = true
vim.opt.incsearch = true
vim.opt.wrapscan  = true
opt.wildignore:append {
  "*/tmp/*",
  "/var/*",
  "*.so",
  "*.swp",
  "*.zip",
  "*.tar",
  "*.pyc"
}
opt.wildmode = {"longest:full","list:full"}


--------------------------------- Appearance ----------------------------------
opt.background    = "dark"
opt.number        = true
opt.relativenumber = false
opt.scrolloff     = 1           -- start scrolling when near the last line
opt.showmatch     = true
opt.showmode      = true
opt.sidescrolloff = 5           -- start scrolling when near the last col
opt.syntax        = 'enable'    -- enable syntax highlighting
opt.termguicolors = true        -- true color support
opt.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
opt.belloff = "all" -- Just turn all the bells off
vim.wo.signcolumn = 'yes'
vim.go.termguicolors = true
vim.go.t_Co = "256"
vim.go.t_ut = ""

--------------------------------- Completion ----------------------------------
-- opt.completeopt = {"menuone", "longest", "preview"}
opt.shortmess = "s"

--------------------------------- Folding ----------------------------------
opt.foldlevel   = 99
opt.foldmethod  = "marker"
opt.foldnestmax = 2

function _G.custom_fold_text()
  local line = vim.fn.getline(vim.v.foldstart)
  local line_count = vim.v.foldend - vim.v.foldstart + 1

  return " ⚡ " ..  ("%4s"):format(line_count) .. " lines ".. line:gsub('"', ""):gsub("{{{", "")
end

vim.opt.foldtext = 'v:lua.custom_fold_text()'
vim.opt.fillchars = { eob = "-", fold = " " }
vim.opt.viewoptions:remove("options")

--------------------------------- General ----------------------------------
opt.clipboard   = 'unnamedplus' -- copy/paste to system clipboard
opt.swapfile    = false         -- don't use swapfile
opt.splitright  = true          -- vertical split to the right
opt.splitbelow  = true          -- orizontal split to the bottom
opt.history     = 10000         -- remember n lines in history
opt.lazyredraw  = true          -- faster scrolling
opt.hidden      = true          -- switch buffers without saving
opt.ttimeout    = true          -- prevent delay when changing modes
opt.ttimeoutlen = 50
opt.updatetime  = 100           -- speed up screen updating
opt.undofile    = false         -- persistent undo
opt.wrap        = false         -- Don't wrap the line if it gets long enough
vim.cmd("set sessionoptions=resize,winpos,winsize,buffers,tabpages,folds,curdir,help")

opt.modeline = false
opt.modelines = 1
opt.formatoptions = opt.formatoptions
  - "a" -- Auto formatting is BAD.
  - "t" -- Don't auto format my code. I got linters for that.
  + "c" -- In general, I like it when comments respect textwidth
  + "q" -- Allow formatting comments w/ gq
  - "o" -- O and o, don't continue comments
  + "r" -- But do continue when pressing enter.
  + "n" -- Indent past the formatlistpat, not underneath it.
  + "j" -- Auto-remove comments if possible.
  - "2" -- I'm not in gradeschool anymore

-- go to last loc when opening a buffer
vim.cmd([[
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
]])

cmd[[au BufWritePre * :%s/\s\+$//e]]   -- remove whitespace on save
