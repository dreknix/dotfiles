"
" Configure plugin ale

" Define used linters
let g:ale_linters = {
  \   'go': ['gofmt', 'golint', 'gobuild', 'gopls'],
  \ }

" Define used fixers
let g:ale_fixers = {
  \   'go': ['gofmt', 'goimports', 'golines', 'remove_trailing_lines', 'trim_whitespace']
  \ }

" End ale
