local cmd  = vim.cmd     		-- execute Vim commands
local exec = vim.api.nvim_exec 	-- execute Vimscript
local fn   = vim.fn       		-- call Vim functions
local g    = vim.g         		-- global variables
local opt  = vim.opt         	-- global/buffer/windows-scoped options

----------------------------- Tabs & Indentation ------------------------------
opt.cursorline  = false
opt.expandtab   = true		-- tabs insert spaces
opt.foldlevel   = 99
opt.foldmethod  = "marker"
opt.foldnestmax = 2
opt.joinspaces  = false		-- only one space after punction when joining lines
opt.list        = false     -- show listchars
opt.listchars   = { extends = "›", precedes = "‹", nbsp = "·", tab = "→ ", trail = "·", eol = "¬" }
opt.shiftwidth  = 4			-- shift 4 spaces when tab
opt.smartindent = true		-- autoindent new lines
opt.smarttab    = true
opt.tabstop     = 4         -- 1 tab == 4 spaces


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
opt.scrolloff     = 1           -- start scrolling when near the last line
opt.showmatch     = true
opt.showmode      = true
opt.sidescrolloff = 5           -- start scrolling when near the last col
opt.syntax        = 'enable'    -- enable syntax highlighting
opt.termguicolors = true        -- true color support
vim.wo.signcolumn = 'yes'

--------------------------------- Completion ----------------------------------
opt.completeopt = {"menuone", "longest", "preview"}
opt.shortmess = "s"

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
opt.linebreak   = true          -- wrap line if too long



cmd[[au BufWritePre * :%s/\s\+$//e]]   -- remove whitespace on save