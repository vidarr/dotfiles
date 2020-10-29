GuiFont! Courier:b:h18

let s:fontsize = 18

function! AdjustFontSize(amount)
    let s:fontsize = s:fontsize + a:amount
    :execute "GuiFont! Courier:b:h" . s:fontsize
endfunction

noremap <A-J> :call AdjustFontSize(-1)<CR>
noremap <A-K> :call AdjustFontSize(1)<CR>
inoremap <A-J> <Esc>:call AdjustFontSize(-1)<CR>
inoremap <A-K> <Esc>:call AdjustFontSize(1)<CR>
