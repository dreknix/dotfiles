"""
""" Configuration: Plugin 'chriskempson/base16-vim'
"""
if !has('gui_running')
  set t_Co=256
  set termguicolors
endif
let base16colorspace=256

" Fix highlighting for spell checks in terminal
function! s:base16_customize() abort
  " Colors: https://github.com/chriskempson/base16/blob/master/styling.md
  " Arguments: group, guifg, guibg, ctermfg, ctermbg, attr, guisp
  call Base16hi("SpellBad",   "", "", "", g:base16_cterm02, "", "")
  call Base16hi("SpellCap",   "", "", "", g:base16_cterm02, "", "")
  call Base16hi("SpellLocal", "", "", "", g:base16_cterm02, "", "")
  call Base16hi("SpellRare",  "", "", "", g:base16_cterm02, "", "")
endfunction

augroup on_change_colorschema
  autocmd!
  autocmd ColorScheme * call s:base16_customize()
augroup END
