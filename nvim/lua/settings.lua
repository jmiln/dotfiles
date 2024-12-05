----------------------------- Tabs & Indentation ------------------------------
vim.opt.expandtab   = true		-- tabs insert spaces
vim.opt.joinspaces  = false		-- only one space after punction when joining lines
vim.opt.list        = false     -- show listchars
vim.opt.listchars   = { extends = "›", precedes = "‹", nbsp = "·", tab = "→ ", trail = "·", eol = "¬" }
-- vim.opt.autoindent = true
-- vim.opt.smartindent = true		-- autoindent new lines
vim.opt.smarttab    = true
vim.opt.shiftwidth  = 4			-- shift 4 spaces when tab
vim.opt.tabstop     = 4         -- 1 tab == 4 spaces
vim.opt.softtabstop = 4         -- 1 tab == 4 spaces
-- vim.opt.indentkeys  = "0{,0},:,0#,!^F,o,O,e,*,<>>,,end,:"

---------------------------------- Searching ----------------------------------
vim.opt.path:append {"**"} -- add current file location to path
vim.opt.ignorecase = true
vim.opt.smartcase  = true
vim.opt.hlsearch   = true
vim.opt.incsearch  = true
vim.opt.magic      = true          -- set magic on, for regular expressions
vim.opt.wrapscan   = true
vim.opt.wildignore:append {
    "*/tmp/*",
    "/var/*",
    "*.so",
    "*.swp",
    "*.zip",
    "*.tar",
    "*.pyc"
}
vim.opt.wildmode = {"longest:full","list:full"}


--------------------------------- Appearance ----------------------------------
vim.opt.background     = "dark"
vim.opt.cursorline     = false
vim.opt.cursorcolumn   = false
vim.opt.number         = true
vim.opt.relativenumber = false
vim.opt.scrolloff      = 1                     -- start scrolling when near the last line
vim.opt.showmatch      = true
vim.opt.showmode       = true
vim.opt.sidescrolloff  = 5                     -- start scrolling when near the last col
vim.opt.syntax         = "enable"              -- enable syntax highlighting
vim.opt.termguicolors  = true                  -- true color support
vim.opt.showbreak      = string.rep(" ", 3)    -- Make it so that long lines wrap smartly
vim.opt.belloff        = "all"                 -- Just turn all the bells off
vim.wo.signcolumn      = "yes"
vim.go.termguicolors   = true

-- Make cursor blink
vim.opt.guicursor = {
    "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50",
    "a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
    "sm:block-blinkwait175-blinkoff150-blinkon175",
}

--------------------------------- Mouse (OFF) ----------------------------------
vim.opt.mouse = ""


-------------------------- Keybinds/ keymapping --------------------------------
vim.g.mapleader = ","
vim.g.maplocalleader = ","

---------------------------------- Completion ----------------------------------
-- vim.opt.completeopt = {"menuone", "longest", "preview"}
vim.opt.shortmess = "s"

----------------------------------- Folding ------------------------------------
vim.opt.foldlevel   = 99
vim.opt.foldmethod  = "expr"
vim.opt.foldexpr    = "nvim_treesitter#foldexpr()"
vim.opt.foldnestmax = 2

function _G.custom_fold_text()
  local line = vim.fn.getline(vim.v.foldstart)
  local line_count = vim.v.foldend - vim.v.foldstart + 1

  return " ⚡ " ..  ("%4s"):format(line_count) .. " lines " .. line:gsub('"', ""):gsub("{{{", "")
end

vim.opt.foldtext = "v:lua.custom_fold_text()"
vim.opt.fillchars = { eob = " ", fold = " " }
vim.opt.viewoptions:remove("options")

--------------------------------- General ----------------------------------
vim.opt.autoread    = false
vim.opt.backspace   = "indent,eol,start"   -- Enable backspacing over autoindent, EOL, and BOL
vim.opt.backup      = false
vim.opt.clipboard   = "unnamedplus" -- copy/paste to system clipboard
vim.opt.complete    = ".,w,b,u,t,i"
vim.opt.encoding    = "UTF-8"
vim.opt.hidden      = true          -- switch buffers without saving
vim.opt.history     = 10000         -- remember n lines in history
-- vim.opt.lazyredraw  = true          -- faster scrolling
vim.opt.mat         = 2             -- how many tenths of a second to blink
vim.opt.numberwidth = 2
vim.opt.ruler       = true
vim.opt.showcmd     = true          -- show incomplete commands
vim.opt.splitbelow  = true          -- orizontal split to the bottom
vim.opt.splitright  = true          -- vertical split to the right
vim.opt.swapfile    = false         -- don't use swapfile
vim.opt.title       = true          -- set terminal title
vim.opt.ttimeout    = true          -- prevent delay when changing modes
vim.opt.ttimeoutlen = 50
vim.opt.undofile    = true         -- persistent undo
vim.opt.undolevels  = 1000          -- Keeps the last 1000 modifications to undo
vim.opt.updatetime  = 100           -- speed up screen updating
vim.opt.whichwrap   = "b,s,h,l,<,>,[,]"
vim.opt.winminheight= 0
vim.opt.wrap        = false         -- Don't wrap the line if it gets long enough
vim.opt.wrapscan    = true          -- Sets it to wrap  search from bottom to top
vim.opt.sessionoptions = "resize,winpos,winsize,buffers,tabpages,folds,curdir,help"

vim.opt.modeline = false
vim.opt.modelines = 1
vim.opt.formatoptions = vim.opt.formatoptions
    - "a" -- Auto formatting is BAD.
        - "t" -- Don't auto format my code. I got linters for that.
        + "q" -- Allow formatting comments w/ gq
        - "o" -- O and o, don't continue comments
    + "r" -- But do continue when pressing enter.
    + "n" -- Indent past the formatlistpat, not underneath it.
    + "j" -- Auto-remove comments when joining

-- Snagged from:
-- https://www.reddit.com/r/neovim/comments/1crdv93/comment/l3z0td3/
-- if ((vim.fn.has("win32") == 1 or vim.fn.has("win64")) and vim.fn.has("wsl") == 0) then
--     vim.o.shell        = "powershell"
--     -- vim.o.shell        = vim.fn.executable "pwsh" == 1 and "pwsh -NoLogo" or "powershell"
--     vim.o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.Encoding]::UTF9;"
--     vim.o.shellredir   = "-RedirectStandardOutput %s -NoNewWindow -Wait"
--     vim.o.shellpipe    = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
--     vim.o.shellquote   = ""
--     vim.o.shellxquote  = ""
-- end

-- Set filetypes for various file extensions
vim.cmd([[au BufNewFile,BufRead *.php,*.html,*.css setlocal nocindent smartindent]])
vim.cmd([[au BufNewFile,BufRead *.ejs set filetype=html]])
vim.cmd([[au BufNewFile,BufRead *.sh  set filetype=bash]])
vim.cmd([[au BufNewFile,BufRead .bashrc,.aliases set filetype=bash]])

-- vim.o.foldcolumn = '1'
-- vim.o.foldlevel = 99
-- vim.o.foldlevelstart = 99
-- vim.o.foldenable = true
-- vim.o.fillchars = [[eob: ,fold: ,foldopen:v,foldsep: ,foldclose:>]]
