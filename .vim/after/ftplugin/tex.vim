"
" Configure plugin ale

" Define used linters
let g:ale_linters = {
      \ 'tex':        ['chktex'],
      \}
" End ale

" use ':make' without makefile
if !filereadable('Makefile')
    setlocal makeprg=pdflatex\ %<\ %
    execute 'let b:undo_ftplugin ' .
        \ (exists('b:undo_ftplugin') ? '.= "|' : '= "') .
        \ 'setlocal makeprg<"'
endif

"
" Open pdf to the current location in a LaTeX file
" https://vim.fandom.com/wiki/Open_pdf_to_the_current_location_in_a_LaTeX_file
"

"Load PDF to the page containing label
function! LoadEvinceByLabel(l)
  for f in split(glob("*.aux"))
    let label = system('grep "^.newlabel{' . a:l . '" ' . f)
    let page = matchstr(label, '.\{}{\zs.*\ze}}')
    if ! empty(page)
      call OpenPDF(substitute(f, "aux$", "pdf", ""), page)
      return
    endif
  endfor
endfunction

"Load PDF to the page containing the nearest previous label to the cursor
function! EvinceNearestLabel()
  let line = search("\\label{", "bnW")
  if line > 0
    let m = matchstr(getline(line), '\\label{\zs[^}]*\ze}')
    if empty(m)
      echomsg "No label between here and start of file"
    else
      call LoadEvinceByLabel(m)
    endif
  endif
endfunction

function! OpenPDF(file,page)
  exec 'silent ! evince --page-label=' . a:page . ' ' . a:file . ' > /dev/null 2>&1 &'
endfunction

" \e
" important to redraw afterwards
nnoremap <buffer> <LocalLeader>e :call EvinceNearestLabel()<CR>:redraw!<CR>

