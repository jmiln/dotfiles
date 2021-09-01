local g = vim.g
local cmd = vim.cmd

cmd[[hi Normal                                                                       guibg=#1C1C1C]]
cmd[[hi Visual        cterm=none                                       guifg=white   guibg=#5f5f5f]]
cmd[[hi Comment       cterm=none      ctermfg=red                      guifg=#d70000 guibg=background]]
cmd[[hi Constant      cterm=none      ctermfg=grey]]
cmd[[hi ColorColumn   cterm=none      ctermfg=none]]
cmd[[hi Error         cterm=none      ctermfg=red       ctermbg=black  guifg=red     guibg=black]]
cmd[[hi Folded        cterm=none      ctermfg=blue      ctermbg=grey   guifg=white   guibg=#5f5f5f]]
cmd[[hi FoldColumn                    ctermfg=59        ctermbg=234    guifg=#5F5F5F guibg=#1C1C1C]]
cmd[[hi Search        cterm=none      ctermfg=blue      ctermbg=grey   guifg=black   guibg=#5f5f5f]]
cmd[[hi MatchParen                                                     guifg=black   guibg=white]]
cmd[[hi Identifier    cterm=none      ctermfg=grey                     guifg=grey]]
cmd[[hi LineNr                        ctermfg=59        ctermbg=234    guifg=#5F5F5F guibg=#1C1C1C]]
cmd[[hi SignColumn                    ctermfg=59        ctermbg=234    guifg=#5F5F5F guibg=#1C1C1C]]
cmd[[hi NonText       cterm=none      ctermfg=88]]
cmd[[hi Normal        cterm=none      ctermfg=grey]]
cmd[[hi PreProc       cterm=none      ctermfg=22]]
cmd[[hi Special       cterm=none      ctermfg=127]]
cmd[[hi Statement     cterm=none      ctermfg=green                    guifg=green4]]
cmd[[hi Statusline    cterm=none      ctermfg=grey]]
cmd[[hi TabLineFill   cterm=none      ctermfg=none]]
cmd[[hi Type          cterm=bold      ctermfg=green                    guifg=green3]]
cmd[[hi VertSplit     cterm=none      ctermfg=blue      ctermbg=grey]]
cmd[[hi Visual        cterm=reverse   ctermfg=none]]

-- " C specific colors
cmd[[hi cStorageClass cterm=none      ctermfg=22]]
cmd[[hi cString       cterm=none      ctermfg=blue]]
cmd[[hi cNumber       cterm=none      ctermfg=18]]
cmd[[hi cConstant     cterm=none      ctermfg=none]]
cmd[[hi cStatement    cterm=none      ctermfg=22]]


-- " SpellCheck specific colors
cmd[[hi SpellBad      cterm=underline ctermfg=88]]
cmd[[hi SpellCap      cterm=underline]]
cmd[[hi SpellRare     cterm=underline]]
cmd[[hi SpellLocal    cterm=underline]]

-- " Completion menu colors
cmd[[hi Pmenu         cterm=none      ctermfg=Cyan                     guifg=white   guibg=#5f5f5f]]
cmd[[hi PmenuSel      cterm=Bold      ctermfg=Black     ctermbg=239    guifg=Black   guibg=darkgrey]]
cmd[[hi PmenuSbar     cterm=none      ctermfg=cyan      ctermbg=Cyan]]
cmd[[hi PmenuThumb    cterm=none      ctermfg=White]]

-- " Cursor specific colores
cmd[[hi CursorLine    cterm=none      ctermfg=none]]
cmd[[hi CursorColumn  cterm=none      ctermfg=none]]
cmd[[hi CursorLineNr  cterm=none      ctermfg=246]]

-- " Removes all styling for cursorline
cmd[[highlight clear CursorLine]]
cmd[[highlight clear CursorLineNR"]]

-- " Git diff coloring
cmd[[hi DiffAdded   gui=NONE guifg=green  guibg=#1C1C1C]]
cmd[[hi DiffChanged gui=NONE guifg=yellow guibg=#1C1C1C]]
cmd[[hi DiffText    gui=NONE guifg=black  guibg=green]]
cmd[[hi DiffRemoved gui=NONE guifg=red    guibg=#1C1C1C]]


