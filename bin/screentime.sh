if ! pgrep -q -i 'screensaver'; then
  date '+%s' >> $HOME/projects/dotfiles/data/screentime
fi
