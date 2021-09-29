require('telescope').setup({
    defaults = {
        file_ignore_patterns = {
            "node_modules",
            ".git"
        }
    }
})

local M = {}

M.search_dotfiles = function()
    require("telescope.builtin").find_files({
        prompt_title = "< Dotfiles >",
        cwd = "~/dotfiles",
        hidden = true,
    })
end

return M
