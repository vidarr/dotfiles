" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:	Markus Toepfer <markus@markustoepfer.com>
" Last Change:	2018 Jan 01

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "mto_dark"

hi Comment    ctermfg=Darkgrey  guifg=darkgrey   term=bold
hi Normal     ctermfg=gray		guifg=gray
hi Constant   ctermfg=darkblue  guifg=darkblue
hi String     ctermfg=yellow    guifg=orange
hi Special    ctermfg=Magenta   guifg=Magenta
hi Identifier ctermfg=Blue      guifg=Blue       term=underline
hi Statement  ctermfg=brown     guifg=brown      term=bold       gui=NONE
hi PreProc    ctermfg=Magenta   guifg=Purple     term=underline
hi Type       ctermfg=Blue      guifg=Blue       term=underline  gui=NONE

:hi CursorLine   cterm=NONE ctermbg=Darkred ctermfg=white guibg=Darkred guifg=white
:hi CursorColumn cterm=NONE ctermbg=Darkred ctermfg=white guibg=darkred guifg=white
:nnoremap <Leader>c :set cursorline! <CR>

hi Visual term=reverse ctermfg=Yellow ctermbg=Red gui=NONE guifg=Black guibg=Yellow
hi Search term=reverse ctermfg=Black ctermbg=Cyan gui=NONE guifg=Black guibg=Cyan
hi Tag term=bold ctermfg=DarkGreen guifg=DarkGreen
hi Error term=reverse ctermfg=15 ctermbg=9 guibg=Red guifg=White
hi Todo term=standout ctermbg=Yellow ctermfg=Black guifg=Blue guibg=Yellow
hi StatusLine term=bold,reverse cterm=NONE ctermfg=Yellow ctermbg=DarkGray gui=NONE guifg=Yellow guibg=DarkGray
hi! link MoreMsg	Comment
hi! link ErrorMsg	Visual
hi! link WarningMsg	ErrorMsg
hi! link Question	Comment
hi link Character	Constant
hi link Number		Constant
hi link Boolean		Constant
hi link Float		Number
hi link Function	Identifier
hi link Conditional	Statement
hi link Repeat		Statement
hi link Label		Statement
hi link Operator	Statement
hi link Keyword		Statement
hi link Exception	Statement
hi link Include		PreProc
hi link Define		PreProc
hi link Macro		PreProc
hi link PreCondit	PreProc
hi link StorageClass	Type
hi link Structure	Type
hi link Typedef		Type
hi link SpecialChar	Special
hi link Delimiter	Special
hi link SpecialComment	Special
hi link Debug		Special
