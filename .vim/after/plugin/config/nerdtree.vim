"""
""" Configuration: Plugin 'preservim/nerdtree'
"""
if exists(":NERDTreeToggle")

  " ignore all pattern from `wildignore`
  let NERDTreeRespectWildIgnore = 1

  nnoremap <Leader>f :NERDTreeToggle<Enter>
  nnoremap <silent> <Leader>v :NERDTreeFind<CR>
  augroup nerdtree
    autocmd!
    " open NERDTree on start if no argument was given
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") && v:this_session == "" | NERDTree | endif
    " close NERDTree if it the last buffer
    autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  augroup END

endif
