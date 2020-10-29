setlocal nosmartindent
setlocal cindent

nnoremap <buffer> <leader>h <esc>O/*<esc>x78p<esc>j:center<CR>0lr*<esc>o<esc>0C *<esc>x78pa/<esc>j
nnoremap <buffer> <leader>s <esc>A/*<esc>78A-<esc>d78<bar>A*/<esc>

nnoremap <buffer> <leader>i <esc>0i#include <<esc>A><esc>0j
nnoremap <buffer> <leader>I kmajdd?#includep0c^#include <A>0`a
