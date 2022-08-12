-- Trouble settings (Show the diagnostics quickfix window automatically)
require("trouble").setup({
    fold_open   = "v",
    fold_closed = ">",
    auto_open   = true,
    auto_close  = true,
    icons       = false,
    signs = {
        -- icons / text used for a diagnostic
        error       = "[ERROR]",
        warning     = "[WARN]",
        hint        = "[HINT]",
        information = "[INFO]",
        other       = "[OTHER]"
    },
})
