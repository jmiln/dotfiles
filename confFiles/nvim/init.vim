" Enable filetype plugins and indention
filetype off
filetype plugin on
filetype plugin indent on       " Turn on filetype specific options

" Install vim-plug if it's not already there
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

" Load up whatever lua stuff
lua require("settings")

" Load up the plugins
lua require("plugins")

" Load all the plugin configs
lua require("config")

" Load up keybinds and such
lua require("keybinds")

" Load up highlighting settings
lua require("highlight")

" Load/ source any .vim files that are in there
" for f in split(glob('~/.config/nvim/config/*.vim'), '\n')
"     exe 'source' f
" endfor

"                   Plugin Settings {{{
"=========================================================

" EasyAlign
" xmap ga <Plug>(EasyAlign)
" nmap ga <Plug>(EasyAlign)

" Close the error window if it's all that's left?
augroup CloseLoclistWindowGroup
    autocmd!
    autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END

" Committia
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
    " Additional settings
    setlocal spell

    " If no commit message, start with insert mode
    if a:info.vcs ==# 'git' && getline(1) ==# ''
        startinsert
    endif

    " Scroll the diff window from insert mode
    " Map <C-n> and <C-p>
    imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
    imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)
endfunction
