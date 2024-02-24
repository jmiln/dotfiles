local constants = require("config.constants")

local augroup = function(name)
  vim.api.nvim_create_augroup(name, { clear = true })
end
local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
  desc = "Turn on wordwrap and spellckeck in text filetypes",
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
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
vim.cmd[[au BufWritePre * :%s/\s\+$//e]]

-- go to last loc when opening a buffer
-- vim.cmd([[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]])
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

