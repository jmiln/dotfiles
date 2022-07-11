require("telescope").setup({
    defaults = {
        file_ignore_patterns = {
            "node_modules",
            ".git"
        },
        layout_config = {
            horizontal = {
                width = 0.9,
                preview_width = 0.6
            }
            -- other layout configuration here
        },
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
