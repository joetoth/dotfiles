xset r rate 250 60                          # keyboard repeat delay and rate
xsetroot -solid darkgrey                    # set root window background
/usr/bin/autocutsel &
/usr/local/bin/barM &
xmodmap ~/.Xmodmap
exec /usr/local/bin/dwm
