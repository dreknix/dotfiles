"""
""" Configuration: Plugin 'vim-airline/vim-airline-themes'
"""
if exists('g:loaded_airline_themes')

  if !has('gui_running')
    set t_Co=256
    set termguicolors
  endif

  let g:airline_theme='base16'

  if exists('$BASE16_THEME')
        \ && (!exists('g:colors_name') || g:colors_name != 'base16-$BASE16_THEME')
    let base16colorspace=256
    colorscheme base16-$BASE16_THEME
  endif
endif
