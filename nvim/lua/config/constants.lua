---- Constants ----

local M = {
    ui = {
        border = "rounded",
    },
    perf = {
        file = {
            maxsize = 1024 * 1024 * 2, -- 2 MB
        },
    },
    root_patterns = {
        ".git",
        "package.json",
    },
}

return M
