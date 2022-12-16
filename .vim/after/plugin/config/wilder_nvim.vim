"""
""" Configuration: Plugin 'gelguy/wilder.nvim'
"""
if &rtp =~ 'wilder.nvim'
  call wilder#setup({
        \ 'modes': [':', '/', '?'],
        \ 'enable_cmdline_enter': 0,
        \ })
  " Use wilder#wildmenu_lightline_theme() if using Lightline
  " 'highlights' : can be overriden, see :h wilder#wildmenu_renderer()
  highlight wilder_selected ctermbg=5 ctermfg=0
  call wilder#set_option('renderer', wilder#wildmenu_renderer(
        \ wilder#wildmenu_airline_theme({
        \   'highlights': {'selected': 'wilder_selected'},
        \   'highlighter': wilder#basic_highlighter(),
        \   'separator': '  ',
        \ })))
endif
