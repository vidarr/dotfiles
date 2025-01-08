GuiFont! Monospace:n:h14

let s:fontsize = 14

function! AdjustFontSize(amount)
    let s:fontsize = s:fontsize + a:amount
    :execute "GuiFont! Monospace:n:h" . s:fontsize
endfunction

noremap <A-J> :call AdjustFontSize(-1)<CR>
noremap <A-K> :call AdjustFontSize(1)<CR>
inoremap <A-J> <Esc>:call AdjustFontSize(-1)<CR>
inoremap <A-K> <Esc>:call AdjustFontSize(1)<CR>
