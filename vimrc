set exrc
set secure

set nocompatible              " be iMproved, required
set encoding=utf-8

filetype plugin on
filetype indent on

set expandtab
set tabstop=4
set shiftwidth=4
set nu

set smartindent
syntax on

" Make backspace behave 'the normal way'
set backspace=indent,eol,start

set hlsearch
set incsearch

set autochdir

" colorscheme desert
syntax enable
" Colors
set background=dark
colorscheme monokai
set guifont=Courier\ 10\ Pitch\ 14
" Highlight column stuff
let g:Colorcolumn = "80,".join(range(120,999),",")
let &colorcolumn=g:Colorcolumn
highlight ColorColumn cterm=NONE ctermbg=234 guibg=#2c2d27
highlight OverLength cterm=NONE ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

" prevent copying line numbers
set mouse=a

" Highlight current line
hi CursorLine   cterm=NONE ctermbg=gray ctermfg=black guibg=gray guifg=black
set cursorline

" Highlight current column
hi CursorColumn cterm=NONE ctermbg=gray ctermfg=black guibg=gray guifg=black
set cursorcolumn

" Always show status line
set laststatus=2

set hidden

let mapleader = '\'

" To open a new empty buffer
nmap <leader>T :enew<cr>

" Move to the next buffer
nmap <leader>l :bnext<CR>

" Move to the previous buffer
nmap <leader>h :bprevious<CR>

" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <leader>bq :bp <BAR> bd #<CR>

" Show all open buffers and their status
nmap <leader>bl :ls<CR>

"
" FuzzyFinder
"
cnorea b FufBuffer<cr>
cnorea e FufFile<cr>

" FSwitch
au! BufEnter *.cpp let b:fswitchdst = 'h' | let b:fswitchlocs = 'rel:.,../src,source,../include,include'
au! BufEnter *.c   let b:fswitchdst = 'h' | let b:fswitchlocs = 'rel:.,../src,source,../include,include'
au! BufEnter *.h   let b:fswitchdst = 'c,cpp' | let b:fswitchlocs = 'rel:.,../src,source,../include,include'
nmap <silent> <Leader>of :FSHere<cr>
nmap <silent> <Leader>ol :FSRight<cr>
nmap <silent> <Leader>oL :FSSplitRight<cr>
nmap <silent> <Leader>oj :FSBelow<cr>
nmap <silent> <Leader>oJ :FSSplitBelow<cr>

cnorea   fb ?\%1c{<CR>
cnorea   fe /\%1c}<CR>
nnoremap <silent> <C-e> :FufFile<CR>
nnoremap <silent> <C-b> :FufBuffer<CR>
nnoremap <silent> <C-f> :FSHere<CR>
nnoremap <silent> <F12> :Texplore<CR>

inoremap <silent> <C-e> :FufFile<CR>
inoremap <silent> <C-b> <Esc>:FufBuffer<CR>
inoremap <silent> <C-f> <Esc>:FSHere<CR>
inoremap <silent> <F12> <Esc>:Texplore<CR>

exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
set list

" CSCOPE
" s: Find this C symbol
nnoremap  <leader>fs :call CscopeFind('s', expand('<cword>'))<CR>
" g: Find this definition
nnoremap  <leader>fg :call CscopeFind('g', expand('<cword>'))<CR>
" d: Find functions called by this function
nnoremap  <leader>fd :call CscopeFind('d', expand('<cword>'))<CR>
" c: Find functions calling this function
nnoremap  <leader>fc :call CscopeFind('c', expand('<cword>'))<CR>
" t: Find this text string
nnoremap  <leader>ft :call CscopeFind('t', expand('<cword>'))<CR>
" e: Find this egrep pattern
nnoremap  <leader>fe :call CscopeFind('e', expand('<cword>'))<CR>
" f: Find this file
nnoremap  <leader>ff :call CscopeFind('f', expand('<cword>'))<CR>
" i: Find files #including this file
nnoremap  <leader>fi :call CscopeFind('i', expand('<cword>'))<CR>

au BufRead,BufNewFile *.dox setfiletype doxygen
au BufRead,BufNewFile *.MD setfiletype markdown

runtime ftplugin/man.vim

au FileType * call Reset_simple_formatting()
au FileType man call Set_simple_formatting()
au FileType netrw call Set_simple_formatting()
au FileType help call Set_simple_formatting() 

function Set_simple_formatting()

    set nolist
    set colorcolumn=0
    set nocursorcolumn

endfunction

function Reset_simple_formatting()

    set list
    let &colorcolumn = g:Colorcolumn
    set cursorcolumn

endfunction


"bufferlist options
let g:BufferListWidth = 80
let g:BufferListMaxWidth = 80

imap <C-w><C-w>  <esc><C-w><C-w>


"markdown support
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']
let g:markdown_syntax_conceal = 0
let g:markdown_minlines = 100

iab *author* (C) 2018 Beer Michael, DLR/GSOC <michael.beer@dlr.de>

" gcov file highlighting support - along with appropriate syntax file
autocmd BufNewFile,BufReadPost *.gcov set filetype=gcov

" When printig from vim (":hardcopy > file.pdf"), interpret form feed (^L) as
" PAGE BREAKS
:set printoptions=formfeed:y

" Fix terminal type if inside gnu screen(1)
if match($TERM, "screen")!=-1
    set term=screen-256color
endif


" Debugging
" set verbose=9

" My statusline
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{StatuslineGit()}
set statusline+=%#LineNr#
set statusline+=\ %f
set statusline+=%m\
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ 


" Markdown preview
nnoremap <silent> <C-p> :MarkdownPreview default<CR>

" Insert separator  ( /*-[-*]*/ ) from end of line to column 80
nnoremap <silent> <leader>s <esc>A/*<esc>78A-<esc>d78<bar>A*/<esc>
" Create 'heading' like separators around a line of text
nnoremap <silent> <leader>h <esc>O/*<esc>x78p<esc>j:center0lr*<esc>o<esc>0C *<esc>x78pa/<esc>j
" Create 'heading' like separators but respecting current indentation
nnoremap <silent> <leader>a <esc>O/*<esc>79a*<esc>d79\|jo <esc>79a*<esc>d79\|s*/<esc>k:center<esc>

" Make '=' use clang-format instead of vim's built-in indentation
autocmd FileType c,cpp,objc map <buffer> = <Plug>(operator-clang-format)
