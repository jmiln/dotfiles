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
opt.syntax        = "enable"    -- enable syntax highlighting
opt.termguicolors = true        -- true color support
opt.showbreak = string.rep(" ", 3) -- Make it so that long lines wrap smartly
opt.belloff = "all" -- Just turn all the bells off
vim.wo.signcolumn = "yes"
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

  return " ⚡ " ..  ("%4s"):format(line_count) .. " lines " .. line:gsub('"', ""):gsub("{{{", "")
end

vim.opt.foldtext = "v:lua.custom_fold_text()"
vim.opt.fillchars = { eob = "-", fold = " " }
vim.opt.viewoptions:remove("options")

--------------------------------- General ----------------------------------
opt.autoread    = false
opt.backspace   = {"indent", "eol,start"}   -- Enable backspacing over autoindent, EOL, and BOL
opt.backup      = false
opt.clipboard   = "unnamedplus" -- copy/paste to system clipboard
opt.complete    = ".,w,b,u,t,i"
opt.encoding    = "UTF-8"
opt.hidden      = true          -- switch buffers without saving
opt.history     = 10000         -- remember n lines in history
opt.indentkeys  = "0{,0},:,0#,!^F,o,O,e,*,<>>,,end,:"
opt.lazyredraw  = true          -- faster scrolling
opt.magic       = true          -- set magic on, for regular expressions
opt.mat         = 2             -- how many tenths of a second to blink
opt.numberwidth = 2
opt.ruler       = true
opt.showcmd     = true          -- show incomplete commands
opt.splitbelow  = true          -- orizontal split to the bottom
opt.splitright  = true          -- vertical split to the right
opt.swapfile    = false         -- don't use swapfile
opt.title       = true          -- set terminal title
opt.ttimeout    = true          -- prevent delay when changing modes
opt.ttimeoutlen = 50
opt.undofile    = false         -- persistent undo
opt.undolevels  = 1000          -- Keeps the last 1000 modifications to undo
opt.updatetime  = 100           -- speed up screen updating
opt.whichwrap   = "b,s,h,l,<,>,[,]"
opt.winminheight= 0
opt.wrap        = false         -- Don't wrap the line if it gets long enough
opt.wrapscan    = true          -- Sets it to wrap  search from bottom to top
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

-- go to last loc when opening a buffer
cmd([[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]])

-- Set filetypes for various file extensions
cmd([[au BufNewFile,BufRead *.php,*.html,*.css setlocal nocindent smartindent]])
cmd([[au BufNewFile,BufRead *.ejs set filetype=html]])
cmd([[au BufNewFile,BufRead .bashrc,.aliases set filetype=bash]])

cmd([[au BufRead,BufNewFile *.json set filetype=json syntax=javascript]])
cmd([[au BufRead,BufNewFile *.js set filetype=javascript syntax=javascript foldmethod=indent]])
cmd([[au BufNewFile,BufRead *.js set foldmethod=syntax]])
cmd("let g:javaScript_fold = 1")

-- Set the .vimrc file to close all relevant folds on open
cmd([[au BufRead,BufNewFile .vimrc set foldlevel=0]])
cmd([[au BufRead,BufNewFile init.vim set foldlevel=0]])

-- Make vim supposedly save/ load view (state) (folds, cursor, etc)
cmd([[au BufWinLeave \* silent! mkview]])
cmd([[au BufWinEnter \* silent! loadview]])

-- Remove whitespace on save
cmd[[au BufWritePre * :%s/\s\+$//e]]