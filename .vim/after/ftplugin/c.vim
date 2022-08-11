"
" Configure plugin ale

" Define used linters
let g:ale_linters = {
      \ 'c':          ['clang'],
      \}
" End ale

" use ':make' without makefile
if !filereadable('Makefile')
    setlocal makeprg=gcc\ -o\ %<\ %
    execute 'let b:undo_ftplugin ' .
        \ (exists('b:undo_ftplugin') ? '.= "|' : '= "') .
        \ 'setlocal makeprg<"'
endif
