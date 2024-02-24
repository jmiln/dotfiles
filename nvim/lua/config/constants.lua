---- Constants ----

local M = {
    diagnostic = {
        sign = {
            error   = "",
            hint    = "",
            info    = "",
            ok      = "",
            warning = "",
        },
    },

    ui = {
        border = "rounded",
    },

    perf = {
        file = {
            maxsize = 1024 * 1024 * 2, -- 2 MB
        },
    },
}

return M
