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

"                   Abbreviations {{{
"=========================================================

" Easy shortcuts for the top of C files
ab #i #include
ab #d #define

" Common bits for js/ node
ab reqins const {inspect} = require("util");
ab inspectdepth inspect(, {depth: 5})

" Useful for eslint
ab nounused // eslint-disable-line no-unused-vars
ab noundef  // eslint-disable-line no-undef

" Useful ones for Discord stuff
ab mslang message.language.get()
ab embedsep '=============================='

" Other shortcuts for splitting/ marking stuff
abb dotlin ……………………………………………………………………………………………………………………………………………………………………………………………
abb cdotlin /*…………………………………………………………………………………………………………………………………………………………………………………*/
abb fdotlin •••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••
abb cfdotlin /*•••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••••*/
abb dlin =======================================================================
abb cdlin /*===================================================================*/
abb lin -----------------------------------------------------------------------
abb clin /*-------------------------------------------------------------------*/
abb ulin _______________________________________________________________________
abb culin /*___________________________________________________________________*/
abb Ulin ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
abb cUlin /*¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯*/

" Various useful symbols
ab chkmrk ✓
ab checkmark ✓

" Typos
cnoreabbrev Q q
cnoreabbrev W w

" }}}
"                   Colorscheme / Syntax Settings {{{
"=========================================================

hi Normal                                                                       guibg=#1C1C1C

hi Visual        cterm=none                                       guifg=white   guibg=#5f5f5f
hi Comment       cterm=none      ctermfg=red                      guifg=#d70000 guibg=background
hi Constant      cterm=none      ctermfg=grey
hi ColorColumn   cterm=none      ctermfg=none
hi Error         cterm=none      ctermfg=red       ctermbg=black  guifg=red     guibg=black
hi Folded        cterm=none      ctermfg=blue      ctermbg=grey   guifg=white   guibg=#5f5f5f
hi FoldColumn                    ctermfg=59        ctermbg=234    guifg=#5F5F5F guibg=#1C1C1C
hi Search        cterm=none      ctermfg=blue      ctermbg=grey   guifg=black   guibg=#5f5f5f
hi MatchParen                                                     guifg=black   guibg=white
hi Identifier    cterm=none      ctermfg=grey                     guifg=grey
hi LineNr                        ctermfg=59        ctermbg=234    guifg=#5F5F5F guibg=#1C1C1C
hi SignColumn                    ctermfg=59        ctermbg=234    guifg=#5F5F5F guibg=#1C1C1C
hi NonText       cterm=none      ctermfg=88
hi Normal        cterm=none      ctermfg=grey
hi PreProc       cterm=none      ctermfg=22
hi Special       cterm=none      ctermfg=127
hi Statement     cterm=none      ctermfg=green                    guifg=green4
hi Statusline    cterm=none      ctermfg=grey
hi TabLineFill   cterm=none      ctermfg=none
hi Type          cterm=bold      ctermfg=green                    guifg=green3
hi VertSplit     cterm=none      ctermfg=blue      ctermbg=grey
hi Visual        cterm=reverse   ctermfg=none

" C specific colors
hi cStorageClass cterm=none      ctermfg=22
hi cString       cterm=none      ctermfg=blue
hi cNumber       cterm=none      ctermfg=18
hi cConstant     cterm=none      ctermfg=none
hi cStatement    cterm=none      ctermfg=22


" SpellCheck specific colors
hi SpellBad      cterm=underline ctermfg=88
hi SpellCap      cterm=underline
hi SpellRare     cterm=underline
hi SpellLocal    cterm=underline

" Completion menu colors
hi Pmenu         cterm=none      ctermfg=Cyan                     guifg=white   guibg=#5f5f5f
hi PmenuSel      cterm=Bold      ctermfg=Black     ctermbg=239    guifg=Black   guibg=darkgrey
hi PmenuSbar     cterm=none      ctermfg=cyan      ctermbg=Cyan
hi PmenuThumb    cterm=none      ctermfg=White

" Cursor specific colores
hi CursorLine    cterm=none      ctermfg=none
hi CursorColumn  cterm=none      ctermfg=none
hi CursorLineNr  cterm=none      ctermfg=246

" Enables cursor line position tracking:
set cursorline

" Removes all styling for cursorline
highlight clear CursorLine
highlight clear CursorLineNR

" Git diff coloring
hi DiffAdded   gui=NONE guifg=green  guibg=#1C1C1C
hi DiffChanged gui=NONE guifg=yellow guibg=#1C1C1C
hi DiffText    gui=NONE guifg=black  guibg=green
hi DiffRemoved gui=NONE guifg=red    guibg=#1C1C1C

au BufNewFile,BufRead *.ejs set filetype=html
let g:html_indent_inctags = "html,body,head,tbody"

" }}}
"                   Folding {{{
"=========================================================
" This will make the folds look nice and neat, with the number of folded lines
" on the right edge
function! MyFoldText()
    let line = getline(v:foldstart)

    let nucolwidth = &fdc + &number * max([&numberwidth, strlen(line('$'))])
    let windowwidth = winwidth(0) - nucolwidth - 6
    let foldedlinecount = v:foldend - v:foldstart

    " Expand tabs into spaces
    let onetab = strpart(' ', 0, &tabstop)
    let line = substitute(line, '\t', onetab, 'g')

    " Clean up the folds for in .vimrc
    " Replace the comment ", and any extra spaces before the title
    let line = substitute(line, '\"\s*', onetab, 'g')
    " Replace the 3 { brackets that mark the fold
    let line = substitute(line, repeat("{", 3), '', 'g')

    let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
    let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
    return line . repeat(" ",fillcharcount) . foldedlinecount . '    '
endfunction
set foldtext=MyFoldText()

" Set the .vimrc file to close all relevant folds on open
au BufRead,BufNewFile .vimrc set foldlevel=0
au BufRead,BufNewFile init.vim set foldlevel=0

" Set folding to be based on syntax for js files
au BufNewFile,BufRead *.js set foldmethod=syntax
let g:javaScript_fold = 1

" restore vim - helping keep settings after closing it
set viewoptions=options,cursor,folds,slash,unix
au BufWinLeave \* silent! mkview  "make vim save view (state) (folds, cursor, etc)
au BufWinEnter \* silent! loadview "make vim load view (state) (folds, cursor, etc)

" }}}
"                   Functions {{{
"=========================================================
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Auto-set paste mode when pasting
" via https://coderwall.com/p/if9mda
function! WrapForTmux(s)
  if !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()


" }}}
"                   Mapping {{{
"=========================================================

" Make it so you can sudo save (For when you forget to open a file with sudo)
cmap ww w !sudo tee > /dev/null
cnoremap w!! w !sudo tee % >/dev/null

" Make easy editing and sourcing vimrc
command! RefreshConfig source $MYVIMRC <bar> echo "Refreshed vimrc!"

" <Leader> sv for sourcing vimrc
nnoremap <leader>sv :RefreshConfig<cr>

" Visual mode pressing * or # searches for the current selection:
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" Search for a word under the cursor in the current dir
" map <leader>* :grep -R <cword> * --exclude-dir={.git,tmp,log,node_modules}<CR><CR>

" Search for a word under the cursor in the current git project
" map <leader>* :Ggrep --untracked <cword><CR><CR>

" Show commit that introduced current line
" nmap <silent><Leader>g :call setbufvar(winbufnr(popup_atcursor(split(system("git log -n 1 -L " . line(".") . ",+1:" . expand("%:p")), "\n"), { "padding": [1,1,1,1], "pos": "botleft", "wrap": 0 })), "&filetype", "git")<CR>

" Some QoL mappings for the autocomplete menu
" imap     <expr> <CR>       pumvisible() ? "\<C-y>" : "\<Plug>delimitMateCR"
" inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
" inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
" inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
" inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

" Makes the arrow keys work in vim, not sure why they had stopped in the first place
" though  still mess up when trying to search)
" set t_ku=OA
" set t_kd=OB
" set t_kr=OC
" set t_kl=OD
"
" map OA <up>
" map OB <down>
" map OC <right>
" map OD <left>
"
" imap <ESC>oA <ESC>ki
" imap <ESC>oB <ESC>ji
" imap <ESC>oC <ESC>li
" imap <ESC>oD <ESC>hi

" " Bubble single lines
" nmap <C-K> ddkP
" nmap <C-J> ddp
"
" " Bubble multiple lines
" " vmap <C-K> xkP`[V`]
" " vmap <C-J> xp`[V`]
"
" " Moving/ bubbling text in visual mode
" vnoremap <C-j> :m '>+1<CR>gv=gv
" vnoremap <C-k> :m '<-2<CR>gv=gv

" turns off the search highlighting
" map <silent> <Space> :nohlsearch <CR>

" Makes it easier to redo
" map <silent> r <C-R>

" Toggle spellcheck
" map <silent> ss :set spell!<CR>

" Select current line, without the indentation
" nnoremap vv ^vg_

" For local replace
" nnoremap gr gd[{V%:s/<C-R>///gc<left><left><left>

" For global replace
" nnoremap gR gD:%s/<C-R>///gc<left><left><left>

" nmap <silent> <F3> :set number!<CR>

" Toggles word wrap
" map <silent> <F4> :set invwrap <CR>

" Toggles the mouse so you can use it for visual mode
" and then back to being able to use it for copy/ paste (does not seem to work on mac)
" nnoremap <silent> <F5> :call ToggleMouse()<CR>
" function! ToggleMouse()
"     if &mouse == 'a'
"         set mouse=
"     else
"         set mouse=a
"     endif
" endfunction

" Toggle pate with <F6>, default is off
" set pastetoggle=off
" set pastetoggle=<F6>

" Toggles the syntax highlighting
" map <silent> <F7> :if exists("syntax_on") <Bar>
"             \   syntax off <Bar>
"             \ else <Bar>
"             \   syntax enable <Bar>
"             \ endif <CR>

" Tells me what syntax attribute is under the cursor
" nnoremap <F8> :call SyntaxAttr()<CR>

" Toggle the invisible stuff
" nnoremap <silent><F9> :set invlist<CR>

" Surround visual selection
" vnoremap ' <esc>`>a'<esc>`<i'<esc>
" vnoremap " <esc>`>a"<esc>`<i"<esc>
" vnoremap ( <esc>`>a)<esc>`<i(<esc>
" vnoremap [ <esc>`>a]<esc>`<i[<esc>
" vnoremap { <esc>`>a}<esc>`<i{<esc>

" Keep search results centered
" nnoremap n nzzzv
" nnoremap N Nzzzv

" Keep selection when shifting
" vnoremap > >gv
" vnoremap < <gv

" as soon as you done search with / or ?, and you want to return to original spot you were at before search just do 's
" nnoremap / ms/
" nnoremap ? ms?

" Put the cursor back to where it was when joining lines
" nnoremap J mzJ`z

" Undo break points
" inoremap , ,<c-g>u
" inoremap . .<c-g>u
" inoremap ! !<c-g>u
" inoremap ? ?<c-g>u

" Search and replace template:
" nnoremap <leader>s :%s///gc<left><left><left><left>


" }}}
"                   Plugin Settings {{{
"=========================================================


" Toggles comments using the tComment plugin

" vnoremap <C-_> gc
" nnoremap <C-_> gcc
" inoremap <C-_> <ESC>gcc

" let g:tcommentLineC='// %s'

" Delimitmate
let delimitMate_expand_cr = 1
let delimitMate_matchpairs = "(:),[:],{:}"

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
autocmd FileType html,ejs,css iunmap <tab>
autocmd FileType html,ejs,css imap <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")

au BufNewFile,BufRead .bashrc,.aliases set filetype=bash

" Supertab settings
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabLongestHighlight = 1

" Enable ycm for only the filestypes it's useful in so it stops screwing with
" stuff here
let g:ycm_filetype_whitelist = {'js': 1, 'json': 1}

" Hexokinase highlighter settings
let g:Hexokinase_highlighters = ['backgroundfull']

"  Ale
" Enable completion where available.
let g:ale_completion_enabled = 1

" Disable checking code unless I save it
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_fix_on_save = 1

" Check & fix JavaScript code with ESlint
let g:ale_linters = {
            \   'javascript': ['eslint'],
            \}
let g:ale_fixers = {
            \   '*': ['remove_trailing_lines'],
            \   'javascript': ['eslint'],
            \}

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_open_list = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Close the error window if it's all that's left?
augroup CloseLoclistWindowGroup
    autocmd!
    autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END




function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? ' OK' : printf(
                \   ' %dW %dE',
                \   all_non_errors,
                \   all_errors
                \)
endfunction

set statusline+=%{LinterStatus()}

" Tagbar
" let g:tagbar_usearrows = 1
" let g:tagbar_singleclick = 1
" let g:tagbar_autofocus = 1
"
" Tagbar binding
" nnoremap <silent><F2> :TagbarToggle<CR>

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



" Nerd Tree

" Check if NERDTree is open or active
function! IsNERDTreeOpen()
    return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
    if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
        NERDTreeFind
        wincmd p
    endif
endfunction

" Close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:NERDTreeDirArrowExpandable = '⯈'
let g:NERDTreeDirArrowCollapsible = '⯆'
let g:NERDTreeIndicatorMapCustom = {
            \ "Modified"  : "✹",
            \ "Staged"    : "✚",
            \ "Untracked" : "✭",
            \ "Renamed"   : "➜",
            \ "Unmerged"  : "═",
            \ "Deleted"   : "✖",
            \ "Dirty"     : "✗",
            \ "Clean"     : "✔︎",
            \ 'Ignored'   : '☒',
            \ "Unknown"   : "?"
            \ }

nnoremap <silent><F11> :NERDTreeFind<cr>
nnoremap <silent><F12> :NERDTreeToggle<cr>


" Highlight currently open buffer in NERDTree
autocmd BufRead * call SyncTree()

" Open NERDTree when you open a file
" autocmd VimEnter * if argc() == 1 | NERDTreeFind | wincmd p | else | NERDTreeFind | endif


" }}}
"                   Settings {{{
"=========================================================
set backspace=indent,eol,start " Enable backspacing over autoindent, EOL, and BOL"
set complete=.,w,b,u,t,i
set encoding=utf-8              " Default encoding
" set esckeys                     " Allow the cursor keys to work
set formatoptions=t             " Fix formatting (line width) when editing"
set laststatus=2
set magic                       " Enable magic (Not really sure...)
set mat=2                       " Time to show matching parens
set matchpairs+=<:>             " Allow matching of brackets too!
set modeline                    " Allow vim options to be embedded in files
set modelines=5                 " they must be within the first or last 5 lines"
set noautoread                  " Don't automatically re-read changed files."
set noautowrite                 " Never write a file unless I request it.
set noautowriteall              " NEVER.
set norelativenumber
set nowrap                      " Lets the lines wrap when the line gets to long
set signcolumn=yes
set numberwidth=2               " Default width of line numbering"
set omnifunc=syntaxcomplete#Complete
set ruler                       " Keeps the block at the bottom right corner that tells what line and column you are on
set showbreak=.                 " What to show a line wrap as
set showcmd
set title                       " Sets the window title so it shows what file you are in
set undolevels=1000             " Keeps the last 1000 modifications to undo
set whichwrap+=b,s,h,l,<,>,[,]  " Lets you move the cursor through line breaks
set winminheight=0
set wrapscan                    " Sets it to wrap searches from bottom to top

" Session Settings
set sessionoptions=resize,winpos,winsize,buffers,tabpages,folds,curdir,help  "

let no_buffers_menu=1

" Backup Settings
set nobackup " disable backup
set undodir=~/.config/nvim/undodir
set undofile

" Disable bell
set visualbell                  " Disable visual bell
set noerrorbells                " Disable error bell
set tm=500

" Joining
set formatoptions+=j            " Remove comment leader when joining lines

" Tab Settings
set tabstop=4 softtabstop=4     " Sets TAB to the same space as four spaces  not seem to be working though)
set shiftwidth=4

" Indenting
set autoindent  " Automatically set the indent of a new line (local to buffer)

" Search Settings
set hlsearch    " Sets it to highlight each word that matches the search
set incsearch   " Sets it to show the search results as the word is typed in

" Sets it so there is no beeping or screen flashes
set vb t_vb="

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
autocmd BufWritePre * :call TrimWhitespace()       " :%s/\s\+$//e

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

"====================
"       tests
"====================

" Tells vim that everything useful is above this
finish


"##############################################################################
"#########################  Key Mappings/ Codes  ##############################
"##############################################################################

" These names for keys are used in the documentation.  They can also be used
" with the ":map" command (insert the key name by pressing CTRL-K and then the
" key you want the name for).
"
" notation  meaning         equivalent  decimal value(s)    ~
"-----------------------------------------------------------------------
" <Nul>     zero            CTRL-@    0 (stored as 10) *<Nul>*
" <BS>      backspace       CTRL-H    8                 *backspace*
" <Tab>     tab             CTRL-I    9                 *tab* *Tab*
"                           *linefeed*
" <NL>      linefeed        CTRL-J   10                 (used for <Nul>)
" <FF>      formfeed        CTRL-L   12                 *formfeed*
" <CR>      car return      CTRL-M   13                 *carriage-return*
" <Return>  same as <CR>                                *<Return>*
" <Enter>   same as <CR>                                *<Enter>*
" <Esc>     escape          CTRL-[   27                 *escape* *<Esc>*
" <Space>   space                    32                 *space*
" <lt>      less-than       <        60                 *<lt>*
" <Bslash>  backslash       \        92                 *backslash* *<Bslash>*
" <Bar>     vertical bar    |       124                 *<Bar>*
" <Del>     delete                  127
"
" <EOL>     end-of-line (can be <CR>, <LF> or <CR><LF>,
"           depends on system and 'fileformat')             *<EOL>*
"
" <Up>      cursor-up                                   *cursor-up* *cursor_up*
" <Down>    cursor-down                                 *cursor-down* *cursor_down*
" <Left>    cursor-left                                 *cursor-left* *cursor_left*
" <Right>   cursor-right                                *cursor-right* *cursor_right*
" <S-Up>    shift-cursor-up
" <S-Down>  shift-cursor-down
" <S-Left>  shift-cursor-left
" <S-Right> shift-cursor-right
" <C-Left>  control-cursor-left
" <C-Right> control-cursor-right
" <F1> - <F12>  function keys 1 to 12                   *function_key* *function-key*
" <S-F1> - <S-F12> shift-function keys 1 to 12          *<S-F1>*
" <Help>        help key
" <Undo>        undo key
" <Insert>  insert key
" <Home>        home                                        *home*
" <End>     end                                         *end*
" <PageUp>  page-up                                     *page_up* *page-up*
" <PageDown>    page-down                                   *page_down* *page-down*
" <kHome>   keypad home (upper left)                    *keypad-home*
" <kEnd>        keypad end (lower left)                     *keypad-end*
" <kPageUp> keypad page-up (upper right)                *keypad-page-up*
" <kPageDown>keypad page-down (lower right)             *keypad-page-down*
" <kPlus>   keypad +                                    *keypad-plus*
" <kMinus>  keypad -                                    *keypad-minus*
" <kMultiply>keypad *                                   *keypad-multiply*
" <kDivide> keypad /                                    *keypad-divide*
" <kEnter>  keypad Enter                                *keypad-enter*
" <kPoint>  keypad Decimal point                        *keypad-point*
" <k0> - <k9>keypad 0 to 9                              *keypad-0* *keypad-9*
" <S-...>   shift-key                                   *shift* *<S-*
" <C-...>   control-key                                 *control* *ctrl* *<C-*
" <A-...>   same as <M-...>                             *<A-*
" <t_xx>        key with "xx" entry in termcap

"##############################################################################

" The ':map' command creates a key map that works in normal, visual, select and operator pending modes.
" The ':map!' command creates a key map that works in insert and command-line mode.
