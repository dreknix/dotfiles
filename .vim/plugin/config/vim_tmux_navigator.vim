"""
""" Configuration:  Plugin 'christoomey/vim-tmux-navigator'
"""
let g:tmux_navigator_no_mappings = 1

""" get the keyboard code use: "sed -n l"

""" Alt + Arrow Keys
nnoremap <silent> <Esc>[1;3D :TmuxNavigateLeft<cr>
nnoremap <silent> <Esc>[1;3B :TmuxNavigateDown<cr>
nnoremap <silent> <Esc>[1;3A :TmuxNavigateUp<cr>
nnoremap <silent> <Esc>[1;3C :TmuxNavigateRight<cr>

""" If the tmux window is zoomed, keep it zoomed when moving from Vim to another pane
let g:tmux_navigator_preserve_zoom = 1

""" Shift + Arrow Keys
nnoremap <silent> <Esc>[1;2D :vertical resize +1<cr>
nnoremap <silent> <Esc>[1;2B :resize +1<cr>
nnoremap <silent> <Esc>[1;2A :resize -1<cr>
nnoremap <silent> <Esc>[1;2C :vertical resize -1<cr>
