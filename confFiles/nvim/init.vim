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

" Load up keybinds and such
lua require("keybinds")

" Load up highlighting settings
lua require("highlight")

" Load/ source any .vim files that are in there
" for f in split(glob('~/.config/nvim/config/*.vim'), '\n')
"     exe 'source' f
" endfor

"                   Folding {{{
"=========================================================

" Set folding to be based on syntax for js files
let g:javaScript_fold = 1

" restore vim - helping keep settings after closing it
set viewoptions=options,cursor,folds,slash,unix

" }}}
"                   Plugin Settings {{{
"=========================================================

" Delimitmate
let delimitMate_expand_cr = 1
let delimitMate_matchpairs = "(:),[:],{:},<:>"

" EasyAlign
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
let g:easy_align_delimiters = {
\ '>': { 'pattern': '>>\|=>\|>' },
\ '/': {
\     'pattern':         '//\+\|/\*\|\*/',
\     'delimiter_align': 'l',
\     'ignore_groups':   ['!Comment'] },
\ ']': {
\     'pattern':       '[[\]]',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ ')': {
\     'pattern':       '[()]',
\     'left_margin':   0,
\     'right_margin':  0,
\     'stick_to_left': 0
\   },
\ 'd': {
\     'pattern':      ' \(\S\+\s*[;=]\)\@=',
\     'left_margin':  0,
\     'right_margin': 0
\   }
\ }

" Emmet
let g:user_emmet_leader_key=','
let g:user_emmet_install_global = 0
" Use emmet only for html and css files
autocmd FileType html,ejs,css,scss EmmetInstall
" Make it so emmet doesn't conflict with other tab completion stuff
" autocmd FileType html,ejs,css iunmap <tab>
" autocmd FileType html,ejs,css imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

au BufNewFile,BufRead .bashrc,.aliases set filetype=bash

" Supertab settings
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabLongestHighlight = 1

" Check & fix JavaScript code with ESlint
let g:ale_linters = {
            \   'javascript': ['eslint'],
            \}
let g:ale_fixers = {
            \   '*': ['remove_trailing_lines'],
            \   'javascript': ['eslint'],
            \}


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


" }}}
"                   Settings {{{
"=========================================================
set backspace=indent,eol,start " Enable backspacing over autoindent, EOL, and BOL"
set complete=.,w,b,u,t,i
set encoding=utf-8              " Default encoding
set laststatus=2
set magic                       " Enable magic (Not really sure...)
set mat=2                       " Time to show matching parens
set noautoread                  " Don't automatically re-read changed files."
set noautowrite                 " Never write a file unless I request it.
set noautowriteall              " NEVER.
set numberwidth=2               " Default width of line numbering"
set omnifunc=syntaxcomplete#Complete
set ruler                       " Keeps the block at the bottom right corner that tells what line and column you are on
set showcmd
set title                       " Sets the window title so it shows what file you are in
set undolevels=1000             " Keeps the last 1000 modifications to undo
set whichwrap+=b,s,h,l,<,>,[,]  " Lets you move the cursor through line breaks
set winminheight=0
set wrapscan                    " Sets it to wrap searches from bottom to top

" Backup Settings
set nobackup " disable backup

" Setting the statusilne formatting
set statusline  =
set statusline +=%1*\ %n\ %*     " Buffer number
set statusline +=[%{&ff}\ -\ %{&fenc}\ -\ %y]  " FileFormat, encoding, fileType
set statusline +=%4*\ %<%f%*     " Full path
set statusline +=%2*%m%*         " Modified flag
set statusline +=%=              " Right align everything after this
set statusline +=Line:%l\/%L\ Column:%c%V\ %P   " Line/lines, column, percentage

" Reload vim when init.vim is written (very useful for when testing)
autocmd! bufwritepost init.vim source %   " When init.vim is written, reload it

" Remove trailing spaces when you save a file
" autocmd BufWritePre * :call TrimWhitespace()       " :%s/\s\+$//e

" Some hopeful settings for php/ html etc.
au BufNewFile,BufRead *.php,*.html,*.css setlocal nocindent smartindent
set indentkeys=0{,0},:,0#,!^F,o,O,e,*,<>>,,end,:

" Set .ejs files to be like html
au BufNewFile,BufRead *.ejs set filetype=html

" Set json files to show nicely
au BufRead,BufNewFile *.json set filetype=json syntax=javascript

" Set js files to fold based on indent since that seems to be the most consistent
au BufRead,BufNewFile *.js set filetype=javascript syntax=javascript foldmethod=indent

" }}}







