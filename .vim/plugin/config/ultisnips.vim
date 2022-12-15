"""
""" Configuration: Plugin 'SirVer/ultisnips'
"""
" Helper Function to get line comment character
function GetCommentMarker()
  if len(split(&l:commentstring, '%s')) == 1
    " if 'commentstring' xx%sxx contains no end part
    return split(&l:commentstring, '%s')[0]
  elseif match(&l:comments, '\v(,|^):[^,:]*(,|$)')
    " if 'comments' contains ',:xxx,'
    return matchstr(&l:comments, '\v(,|^):\zs[^,:]*\ze(,|$)')
  else
    echoerr 'unable to find line comment marker.'
  endif
endfunction
" Some variables need default value
if !exists('g:snips_author')
    let g:snips_author = 'dreknix'
endif
if !exists('g:snips_email')
    let g:snips_email = 'dreknix@proton.me'
endif
if !exists('g:snips_github')
    let g:snips_github = 'https://github.com/dreknix'
endif
" Use <tab> key
"let g:UltiSnipsExpandTrigger='<tab>'
"let g:UltiSnipsJumpForwardTrigger='<tab>'
"let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit='vertical'
