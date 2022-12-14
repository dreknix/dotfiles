"""
""" Configuration: Plugin 'sgur/vim-editorconfig'
"""
" Softtabs, 2 spaces
set tabstop=2
set softtabstop=0
set shiftwidth=2
set shiftround
set expandtab
" check which plugin or file set the variable
":verbose set tabstop

if has("autocmd")
  autocmd BufRead,BufNewFile Makefile*   :set noexpandtab
endif

let g:editorconfig_blacklist = {
      \ 'filetype': ['git.*', 'fugitive'],
      \ 'pattern': ['\.un~$'] }
" editorconfig_root_chdir is dangerous since it makes a lcd to change
" the direcory and breaks so several other vim settings
"let g:editorconfig_root_chdir = 1
let g:editorconfig_verbose = 1
