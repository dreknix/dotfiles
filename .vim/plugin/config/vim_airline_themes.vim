"""
""" Configuration: Plugin 'vim-airline/vim-airline-themes'
"""
let g:airline_theme='base16'

set background=dark
if !exists('g:colors_name') || g:colors_name != 'base16-tomorrow-night'
  colorscheme base16-tomorrow-night
endif
