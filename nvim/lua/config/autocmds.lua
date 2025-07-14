local constants = require("config.constants")

local augroup = function(name)
    vim.api.nvim_create_augroup(name, { clear = true })
end
local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
    desc = "Turn on wordwrap and spellckeck in text filetypes",
    group = augroup("wrap_spell"),
    pattern = { "gitcommit", "markdown", "text" },
    callback = function()
        vim.opt_local.linebreak = true
        vim.opt_local.spelllang = "en_us"
        vim.opt_local.spell = true
        vim.opt_local.wrap = true
    end,
})

-- When in the popup buffers, map q to close it
autocmd("FileType", {
  pattern = { "checkhealth", "fugitive*", "git", "help", "man", "lspinfo", "netrw", "notify", "noice", "qf", "query", "Trouble", "trouble", },
  callback = function()
    vim.keymap.set("n", "q", vim.cmd.close, { desc = "Close the current buffer", buffer = true })
  end,
})

-- Set filetypes for various file extensions
vim.cmd([[au BufNewFile,BufRead *.php,*.html,*.css setlocal nocindent smartindent]])
autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.ejs",
    callback = function()
        vim.bo.filetype = "html"
    end,
})
autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.sh", ".bashrc", ".aliases" },
    callback = function()
        vim.bo.filetype = "bash"
    end,
})
autocmd({ "BufNewFile", "BufRead" }, {
    pattern = "*.conf",
    callback = function()
        vim.bo.filetype = "conf"
    end,
})

autocmd("BufWritePre", {
    desc = "Auto create dir when saving a file, in case some intermediate directory does not exist",
    group = augroup("auto_create_dir"),
    callback = function(event)
        if event.match:match("^%w%w+://") then
            return
        end
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

-- If a file is larger than 2MB, turn off some settings to make it load faster
--  * The foldmethod itself seems to be a massive part of it, at least with large json files
vim.api.nvim_create_autocmd("BufReadPre", {
    callback = function()
        local f = vim.fn.expand("<afile>")
        if vim.fn.getfsize(f) > constants.perf.file.maxsize then
            vim.notify("Big file, disabling syntax, folding, filetype")
            vim.cmd([[
                syntax clear
                filetype off
                set foldmethod=manual
            ]])
        end
    end,
})

-- Remove whitespace on save
vim.cmd([[au BufWritePre * :%s/\s\+$//e]])

-- go to last loc when opening a buffer
-- vim.cmd([[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]])
-- vim.api.nvim_create_autocmd("BufReadPost", {
--     callback = function()
--         local mark = vim.api.nvim_buf_get_mark(0, '"')
--         local lcount = vim.api.nvim_buf_line_count(0)
--         if mark[1] > 0 and mark[1] <= lcount then
--             pcall(vim.api.nvim_win_set_cursor, 0, mark)
--         end
--     end,
-- })

-- As above, but from https://github.com/hieulw/nvimrc/blob/lua-config/lua/hieulw/autocmds.lua
autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
  desc = "remember cursor position, folds of current buffer",
  pattern = "?*",
  group = augroup("remember_folds"),
  callback = function(e)
    if vim.b[e.buf].view_activated then
      vim.cmd.mkview({ mods = { emsg_silent = true } })
    end
  end,
})
autocmd("BufWinEnter", {
  desc = "load cursor position, folds of current buffer",
  pattern = "?*",
  group = augroup("remember_folds"),
  callback = function(e)
    if not vim.b[e.buf].view_activated then
      local filetype = vim.api.nvim_get_option_value("filetype", { buf = e.buf })
      local buftype = vim.api.nvim_get_option_value("buftype", { buf = e.buf })
      local ignore_filetypes = { "gitcommit", "gitrebase" }
      if buftype == "" and filetype and filetype ~= "" and not vim.tbl_contains(ignore_filetypes, filetype) then
        vim.b[e.buf].view_activated = true
        vim.cmd.loadview({ mods = { emsg_silent = true } })
      end
    end
  end,
})

autocmd("BufWritePre", {
  desc = "auto create dir when saving a file, in case some intermediate directory does not exist",
  group = augroup("auto_create_dir"),
  callback = function(e)
    if e.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(e.match) or e.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

---@see https://www.reddit.com/r/neovim/comments/zy5s0l/you_dont_need_vimrooter
-- Messes with opening tmux panes when the chdir is there
autocmd("BufEnter", {
  desc = "Find the project root",
  group = augroup("change_root"),
  callback = function(e)
    RootCache = RootCache or {}
    local root_patterns = constants.root_patterns
    local path = vim.api.nvim_buf_get_name(e.buf)
    if path == "" then
      return
    end

    local root = RootCache[vim.fs.dirname(path)]
    if root == nil then
      root = vim.fs.root(e.buf, root_patterns)
      RootCache[path] = root
    end

    -- if root ~= nil and root ~= "" then
    --   vim.fn.chdir(root)
    -- end
  end,
})

autocmd("FileType", {
    pattern = { "help", "checkhealth" },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", {
            buffer = event.buf,
            silent = true,
            desc = "Quit buffer",
        })
    end,
})


