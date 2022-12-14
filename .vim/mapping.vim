"
" Key mappings
"

" TODO improve german keyboard, e.g.
map ö [
map ä ]
map Ö {
map Ä }
map ß /

" arrow keys
"nnoremap <Up>    <Nop>
"nnoremap <Down>  <Nop>
"nnoremap <Left>  <Nop>
"nnoremap <Right> <Nop>
"inoremap <Up>    <Nop>
"inoremap <Down>  <Nop>
"inoremap <Left>  <Nop>
"inoremap <Right> <Nop>

" function keys (windows keyboard -> press '[f] Umsch' first

" <F1> - is help key for vim
" <F2> - toogle display of unprintable characters (see `listchars`)
nnoremap <F2> :set list!<CR>
inoremap <F2> <ESC>:set list!<CR>i
" <F3> - toogle display of line numbers (see `numberwidth`)
nnoremap <F3> :set number!<CR>
inoremap <F3> <ESC>:set number!<CR>i
" <F4> - toogle display of relative line numbers
nnoremap <F4> :set relativenumber!<CR>
inoremap <F4> <ESC>:set relativenumber!<CR>i
" <F5> - toogle ALE signs in gutter
" <F8> - toogle Tagbar

" <C-L> (redraw screen) - turn off search highlighting until next search
nnoremap <C-L> :nohlsearch<CR><C-L>

nnoremap <leader>b :bnext<CR>
nnoremap <leader>B :bprevious<CR>

" Edit vimrc configuration file
nnoremap <Leader>ve :e $MYVIMRC<CR>
" Reload vimrc configuration file
nnoremap <Leader>vr :source $MYVIMRC<CR>
