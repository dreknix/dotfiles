"""
""" Configuration: Plugin 'vim-airline/vim-airline'
"""
set noshowmode     " show no mode information
let g:airline_powerline_fonts = 1
" do not show spell info in status line
let g:airline_detect_spell=0
" extensions
let g:airline#extensions#tabline#enabled = 1  " enable a tabline for buffers
let g:airline#extensions#tabline#switch_buffers_and_tabs = 1
