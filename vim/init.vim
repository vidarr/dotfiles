source $HOME/.vimrc

" For installing vim-plug, do
" curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

" Install the plugins with
"
" In nvim: :PlugInstall
"
call plug#begin('~/.local/share/nvim/plugged')

" Requires: nodejs.
" Install with
" curl -sL install-node.now.sh/lts | bash
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

" Use coc instead of built-in goto-definition
nmap <silent> gd <Plug>(coc-definition)
