"""
""" Configuration: Plugin 'gelguy/wilder.nvim'
"""
call wilder#setup({
      \ 'modes': [':', '/', '?'],
      \ 'enable_cmdline_enter': 0,
      \ })
" Use wilder#wildmenu_lightline_theme() if using Lightline
" 'highlights' : can be overriden, see :h wilder#wildmenu_renderer()
" TODO: highlight color is currently red should be changed <10.12.22, dreknix>
call wilder#set_option('renderer', wilder#wildmenu_renderer(
      \ wilder#wildmenu_airline_theme({
      \   'highlights': {},
      \   'highlighter': wilder#basic_highlighter(),
      \   'separator': '  ',
      \ })))
