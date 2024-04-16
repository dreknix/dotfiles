#!/usr/bin/env bash
#
# $ sudo apt install imagemagick imagemagick-doc feh
#
# Enable '@' in /etc/ImageMagick-6/policy.xml
#

txtFile=$(mktemp /tmp/convert-feh-XXXXXX.txt)

dir=$(dirname "$txtFile")
file=$(basename "$txtFile .txt")

pngFile="${dir}/${file}.png"

cat > "${txtFile}" << EOF
       tmux General Shortcuts         |         tmux Window Shortcuts           |          tmux Pane Shortcuts 
                                        |                                           |
Ctrl + A  ? - list all shortcuts        |  Ctrl + A  C - create window              |  Ctrl + A  % - split pane vertically
                                        |  Ctrl + A  , - rename current window      |  Ctrl + A  " - split pane horizontally
Ctrl + A  $ - rename current session    |  Ctrl + A  & - close current window       |  Ctrl + A  ; - toggle last active pane
Ctrl + A  D - detach from tmux          |  Ctrl + A  W - show all windows           |  Ctrl + A  Q - show pane numbers
Ctrl + A  S - show all sessions         |  Ctrl + A  p - switch to previous window  |            0..9 - switch to pane after show
Ctrl + A  ( - move to previous session  |  Ctrl + A  n - switch to next window      |  Ctrl + A  ! - convert a pane to window
Ctrl + A  ) - move to next session      |  Ctrl + A  0..9 - switch to window        |  Ctrl + A      - switch to pane (direction)
                                        |  :swap-window -s 2 -t 1 - swap 2 with 1   |  Ctrl + A +     - resize current pane
Ctrl + A  : - enter command mode        |  :swap-window -t -1 - move window left    |  :setw synchronize-panes
Alt  + ö    - enter copy mode           |  Create a new Window in different dir     |  Ctrl + A  v - split pane vertically (rel. path)
                                        |  :new-window -c path                      |  Ctrl + A  h - split pane horizontally (rel. path)


     VIM Keyboard Shortcuts     |      VIM Keyboard Shortcuts      |      VIM Keyboard Shortcuts     |           VIM Commands 
                                  |                                    |                                   |
:e filename - edit in new buffer  |  F2 - toogle unprintable chars     |  är / ]r - next ALE finding       |  ci - change exclusive inner match
Ctrl + C - next buffer (tab)      |  F3 - toogle line numbers          |  ör / ]r - previous ALE finding   |  di - delete exclusive inner match
Ctrl + D - previous buffer (tab)  |  F4 - toogle relatuve numbers      |                                   |  ct - change up to (exclude)
:bd - delete buffer (close file)  |  F5 - toogle ALE signs             |  äs / ]s - next spell error       |  dt - delete up to (exclude)
                                  |                                    |  ös / [s - previous spell error   |  cf - change up to (include)
Ctrl + W  S - split horizontally  |  V - visual selection              |  z= - suggest words               |  df - delete up to (exclude)
Ctrl + W  V - split vertically    |  " + y - copy to X11 clipboard     |  zg - insert word in list         |  ca - change inclusive inner match
Ctrl + W  W - next pane           |  " + p - paste from X11 clipboard  |  zug - remove word in list        |  da - delete inclusive inner match
Ctrl + W  Q - exit pane           |                                    |                                   |  e.g.: ci" or dt{
                                  |                                    |  Ctrl + L - turn off search       |  p - w - " - ' - ( - { - < - t


     Gnome Keyboard Shortcuts 

  Ctrl + Y - This help page

   + S - Search in files
   + X - Run rofi menu
   + C - Get gopass passwords
   + V - Run SSH menu
   + B - Search in directories

  Ctrl + Alt + 󰛂 - Workspace down
  Ctrl + Alt + 󰛁 - Workspace up
EOF

bg='#8abeb7'
fg='#1d1f21'
size='2000x2000'
fontfamily='Hack-Nerd-Font-Regular'
fontsize='14'

convert -size "$size" \
        -font "$fontfamily" \
        -pointsize "$fontsize" \
        -annotate +20+20 "@${txtFile}" \
        -trim \
        xc:$bg \
        -fill "$fg" \
        -bordercolor "$bg" \
        -border 20 \
        +repage \
        "${pngFile}"

feh --title "feh infosheet" --image-bg $bg -F "${pngFile}"

rm -f "${txtFile}"
rm -f "${pngFile}"
