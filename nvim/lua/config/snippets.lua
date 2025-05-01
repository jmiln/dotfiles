local luasnip = require("luasnip")

local snip = luasnip.snippet
local text = luasnip.text_node
local insert = luasnip.insert_node

-- Add snippets for JS files
luasnip.add_snippets("javascript", {
    -- Javascript helpers
    snip( "reqins", { text('const { inspect } = require("node:util");') }),
    snip( "inspectdepth", { text("inspect("), insert(1), text(", {depth: 5});")}),

    -- ESLint helpers
    -- snip( "nounused", { text("// eslint-disable-line no-unused-vars") }),
    -- snip( "noundef",  { text("// eslint-disable-line no-undef") }),
})

-- Add stuff for any file type (Replacing abbreviations)
luasnip.add_snippets("all", {
    -- Various useful symbols
    snip( "checkmark", { text("✓") })
})
