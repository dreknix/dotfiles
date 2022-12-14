"""
""" Configuration: Plugin 'kien/ctrlp.vim'
"""
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
" 'r' - the nearest ancestor that contains one of these directories or files:
"       .git .hg .svn .bzr _darcs, and your own root markers defined with the
"       g:ctrlp_root_markers option.
" 'a' - like 'c', but only applies when the current working directory outside
"       of CtrlP isn't a direct ancestor of the directory of the current file.
let g:ctrlp_working_path_mode = 'ra'
" Exclude files or directories using Vim's wildignore:
set wildignore+=*/tmp/*,*.so,*.swp,*~,*.bak,*.zip
" Exclude files or directories using CtrlP option
" TODO: add option for ignore also .gitignore files <10.12.22, dreknix>
let g:ctrlp_custom_ignore = {
	\ 'dir':  '\v[\/]\.(git|hg|svn)$',
	\ 'file': '\v\.(exe|so|dll)$',
	\ 'link': 'SOME_BAD_SYMBOLIC_LINKS',
	\ }
