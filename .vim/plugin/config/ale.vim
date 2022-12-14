"""
""" Configuration: Plugin 'dense-analysis/ale'
"""
" see below:
" nnoremap <F5> :ALEToggle<CR>
" inoremap <ESC><F5> :ALEToggle<CR>i

let g:ale_completion_enabled = 1
let g:ale_sign_column_always = 1
let g:ale_sign_error = ''
let g:ale_sign_warning = ''
let g:ale_sign_info = ''
highlight ALEErrorSign ctermfg=9 ctermbg=18 guifg=#cc6666 guibg=#373b41
highlight ALEWarningSign ctermfg=11 ctermbg=18 guifg=#f0c674 guibg=#373b41
highlight ALEInfoSign ctermfg=10 ctermbg=18 guifg=#b5bd68 guibg=#373b41
" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1
"
" INFORMATION
" Setting g:ale_linters and g:ale_fixers in the filetype specific file in
" ~/.vim/after/ftplugin/filetype.vim
"
" Only run linters named in g:ale_linters settings.
let g:ale_linters_explicit = 1
" Enable fixers at writing file
let g:ale_fix_on_save = 1
" Map keys CTRL-j and CTRL-k to moving between errors
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" <F5> - toogle ALE signs in gutter
nnoremap <F5> :ALEToggle<CR>
inoremap <ESC><F5> :ALEToggle<CR>i

" move between ALE linting errors/warnings/infos
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>
