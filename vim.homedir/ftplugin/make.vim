setlocal nosmartindent
setlocal cindent

setlocal nowrap

nnoremap <buffer> <leader>h <esc>^yyPjkC/*<esc>80i*<esc>79<bar>Dyyjpr $r/<esc>k:center<cr>0jo<esc>
nnoremap <buffer> <leader>s <esc>A/*<esc>78A-<esc>d78<bar>A*/<esc>
nnoremap <buffer> <leader>c <esc>:center<cr>O/<esc>hj3s /*<esc>kddA <esc>x80p078lC*/<esc>o<esc>

nnoremap <buffer> <leader>i kmajdd?#include<CR>p0c^#include "<esc>A"<esc>0`a
nnoremap <buffer> <leader>I kmajdd?#include<CR>p0c^#include <<esc>A><esc>0`a
