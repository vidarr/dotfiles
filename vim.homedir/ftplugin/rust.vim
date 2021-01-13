setlocal nowrap

let g:clang_format#command = "rustfmt"
let g:clang_format#extra_args = "--force"

nnoremap <buffer> <leader>h <esc>O/*<esc>x78p<esc>j:center<CR>0lr*<esc>o<esc>0C *<esc>x78pa/<esc>j
nnoremap <buffer> <leader>s <esc>A/*<esc>78A-<esc>d78<bar>A*/<esc>
