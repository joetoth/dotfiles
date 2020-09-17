# .bashrc for OS X and Ubuntu

# System default
# --------------------------------------------------------------------

##export PLATFORM=$(uname -s)
#[ -f /etc/bashrc ] && . /etc/bashrc
#
#BASE=$(dirname $(readlink $BASH_SOURCE))
#
#if [[ -f /etc/bash_completion ]] && ! shopt -oq posix; then
#  . /etc/bash_completion
#fi
#
## Options
## --------------------------------------------------------------------
#
#### Append to the history file
#shopt -s histappend
#
## After each command, append to the history file and reread it
#export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
#
#### Check the window size after each command ($LINES, $COLUMNS)
#shopt -s checkwinsize
#
#### Better-looking less for binary files
#[ -x /usr/bin/lesspipe    ] && eval "$(SHELL=/bin/sh lesspipe)"
#
#### Bash completion
#[ -f /etc/bash_completion ] && . /etc/bash_completion
#
#### Disable CTRL-S and CTRL-Q
#[[ $- =~ i ]] && stty -ixoff -ixon
#
#BASE16_SHELL=$HOME/projects/dotfiles/base16-shell/
#[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
#
## Environment variables
## --------------------------------------------------------------------
#
#### man bash
#export HISTCONTROL=ignoreboth:erasedups
#export HISTSIZE=
#export HISTFILESIZE=
#export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "
#[ -z "$TMPDIR" ] && TMPDIR=/tmp
#
#### Global
#export GOPATH=~/projects/go
#mkdir -p $GOPATH
#if [ -z "$PATH_EXPANDED" ]; then
#  export PATH=~/bin:/opt/bin:/usr/local/bin:/usr/local/share/python:$GOPATH/bin:/usr/local/opt/go/libexec/bin:$PATH
#  export PATH_EXPANDED=1
#fi
#export EDITOR=vim
#export LANG=en_US.UTF-8
#export LC_ALL=en_US.UTF-8
#[ "$PLATFORM" = 'Darwin' ] ||
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.:/usr/local/lib
#
#### OS X
#export COPYFILE_DISABLE=true
#
## Aliases
## --------------------------------------------------------------------
#
#alias ..='cd ..'
#alias ...='cd ../..'
#alias ....='cd ../../..'
#alias .....='cd ../../../..'
#alias ......='cd ../../../../..'
#alias cd.='cd ..'
#alias cd..='cd ..'
#alias l='ls -alF'
#alias ll='ls -alh --color=auto'
#alias lt='ls -alhrt --color=auto'
#alias ls='ls -h --color=auto'
#alias lss='ls -SlaGh --color=auto'
#alias topdirs='du -m . | sort -nr | head -n 100'
#alias debugon='set -x'
#alias debugoff='set +x'
#alias lsg='ll | grep'
#alias vi='vim'
#alias vi2='vi -O2 '
#alias hc="history -c"
#alias which='type -p'
#alias k5='kill -9 %%'
#alias gs='git status'
##alias gv='vim +GV +"autocmd BufWipeout <buffer> qall"'
#alias reset-keyboard='setxkbmap -model pc104 -layout us'
#alias what_port_app='sudo netstat -nlp | grep'
##alias pomo='(sleep 1500 && notify-send -u critical "BREAK BREAK BREAK\nBREAK BREAK BREAK\nBREAK BREAK BREAK\nBREAK BREAK BREAK\nBREAK BREAK BREAK")&'
#alias learnd='python $HOME/bin/python/learn.py --daemon=true'
#alias learn-concept='python $HOME/bin/python/learn.py --concept '
#alias learn-printall='python $HOME/bin/python/learn.py --printall=true'
#alias rekall='python $HOME/bin/python/learn.py --rekall=true --concept'
#alias learn-remove='python $HOME/bin/python/learn.py --remove=true --concept'
#
#alias r='source $HOME/.bashrc'
#alias ve='vim ~/.vimrc'
#alias be='$EDITOR $HOME/.bashrc'
#alias bwe='$EDITOR $HOME/wdf/work.bash'
#
#alias invert-laptop='xrandr --output eDP1 --rotate inverted'
#alias pyserve='python -m SimpleHTTPServer 8000'
#alias ipython3='ipython3 --TerminalInteractiveShell.editing_mode=vi'
#
#alias touchpadoff='synclient Touchpadoff=1'
#alias touchpadon='synclient Touchpadoff=0'
#
## create __init__.py files in every directory, allowing Intellj to treat each directory as a python module and now all imports will work.
#alias python_add_init="find . -type d -exec touch '{}/__init__.py' \;"
#alias tfc='rm -rf /tmp/tf'
#alias tb='tensorboard --logdir=/tmp/tf'
#
#alias clipster-daemon='clipster -f ~/clipster.ini -d'
#alias lock='xscreensaver-command -lock'
#alias battery='upower -i $(upower -e | grep "BAT") | grep -E "state|to\ full|percentage"'
#alias cdp='cd ~/projects'
#
#alias gac='git commit -a -m'
#alias gco='git checkout'
#alias git-magic-rebase='git rebase --onto work $(git5 status --base) $(git rev-parse --abbrev-ref HEAD)'
#alias gn='git diff --name-only --relative | uniq'
##alias glg="git log --graph --decorate --all --pretty='$git_log_defaults'"
#alias grc='git add -A && git rebase --continue'
#alias gaa='git add -A'
#alias gs='git stash'
#alias gsp='git stash pop'
#
## FUNCTIONS
#source_if_exists() {
#  [[ -s $1 ]] && source $1
#}
#
#javatests() {
#  javatests=$(</dev/stdin)
#  javatests=$(echo $javatests | grep -oh -P "(//java.+?\s)")
#  export javatests
#}
#
#du-size() {
# du -a $1 | sort -n -r | head -n 100
#}
#
#goog() {
#  google-chrome "-app=http://google.com/#q=$@"
#}
#
#writecmd() {
#    perl -e '$TIOCSTI = 0x5412; $l = <STDIN>; $lc = $ARGV[0] eq "-run" ? "\n" : ""; $l =~ s/\s*$/$lc/; map { ioctl STDOUT, $TIOCSTI, $_; } split "", $l;' -- $1
#}
#
#night_mode() {
#    for disp in $(xrandr | sed -n 's/^\([^ ]*\).*\<connected\>.*/\1/p'); do
#        xrandr --output $disp --gamma $1 --brightness $2
#    done
#}
#
##cd into the directory of the selected file
#cdf() {
#   local file
#   local dir
#   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
#}
#
#dev() {
#	echo "watching $1"
#	while true; do 
#   inotifywait -r $1
#		echo "$2"
#		eval "$2"
#  done
#}
#
#record_changes() {
#	while true; do 
#    filename=$(inotifywait -e close_write -r -q --format %w%f $1)
#		echo "$filename"
#  done
#}
#
#alias bluelight_on='night_mode 1:1:1   1.0'
#alias bluelight_off='night_mode 1:1:0.7   1.0'
#
## PATH for the Google Cloud SDK and completion
#source_if_exists $HOME/opt/google-cloud-sdk/path.bash.inc
#source_if_exists $HOME/opt/google-cloud-sdk/completion.bash.inc 
#source_if_exists $HOME/wdf/work.bash
#
## search contents of current directory and open file in editor
#s() {
#  local selected
#  if selected=$(ag --nobreak --nonumbers --noheading . | fzf -q "$LBUFFER"); then
##  local files
##  IFS=$'\n' files=($(fzf-tmux --query="$1" --multi --select-1 --exit-0))
#    [[ -n "$selected" ]] && ${EDITOR:-vim} "${selected[@]}"
#  fi
#}
#
#ext() {
#  local name=$(basename $(pwd))
#  cd ..
#  tar -cvzf "$name.tgz" --exclude .git --exclude target --exclude "*.log" "$name"
#  cd -
#  mv ../"$name".tgz .
#}
#temp() {
#  vim +"set buftype=nofile bufhidden=wipe nobuflisted noswapfile tw=${1:-0}"
#}
#
#if [ "$PLATFORM" = 'Darwin' ]; then
#  alias tac='tail -r'
#  o() {
#    open --reveal "${1:-.}"
#  }
#fi
#
#### Tmux
#alias tmux="tmux -2"
#alias tmuxls="ls $TMPDIR/tmux*/"
#tping() {
#  for p in $(tmux list-windows -F "#{pane_id}"); do
#    tmux send-keys -t $p Enter
#  done
#}
#tpingping() {
#  [ $# -ne 1 ] && return
#  while true; do
#    echo -n '.'
#    tmux send-keys -t $1 ' '
#    sleep 10
#  done
#}
#
#
#### Colored ls
#if [ -x /usr/bin/dircolors ]; then
#  eval "`dircolors -b`"
#  alias ls='ls --color=auto'
#  alias grep='grep --color=auto'
#elif [ "$PLATFORM" = Darwin ]; then
#  alias ls='ls -G'
#fi
#
#
## Prompt
## --------------------------------------------------------------------
#source $HOME/projects/liquidprompt/liquidprompt
#
#
## Tmux tile
## --------------------------------------------------------------------
#
#tt() {
#  if [ $# -lt 1 ]; then
#    echo 'usage: tt <commands...>'
#    return 1
#  fi
#
#  local head="$1"
#  local tail='echo -n Press enter to finish.; read'
#
#  while [ $# -gt 1 ]; do
#    shift
#    tmux split-window "$SHELL -ci \"$1; $tail\""
#    tmux select-layout tiled > /dev/null
#  done
#
#  tmux set-window-option synchronize-panes on > /dev/null
#  $SHELL -ci "$head; $tail"
#}
#
#
## Shortcut functions
## --------------------------------------------------------------------
#
#..cd() {
#  cd ..
#  cd "$@"
#}
#
#_parent_dirs() {
#  COMPREPLY=( $(cd ..; find . -mindepth 1 -maxdepth 1 -type d -print | cut -c3- | grep "^${COMP_WORDS[COMP_CWORD]}") )
#}
#
#complete -F _parent_dirs -o default -o bashdefault ..cd
#
#viw() {
#  vim `which "$1"`
#}
#
#gd() {
#  [ "$1" ] && cd *$1*
#}
#
#csbuild() {
#  [ $# -eq 0 ] && return
#
#  cmd="find `pwd`"
#  for ext in $@; do
#    cmd=" $cmd -name '*.$ext' -o"
#  done
#  echo ${cmd: 0: ${#cmd} - 3}
#  eval "${cmd: 0: ${#cmd} - 3}" > cscope.files &&
#  cscope -b -q && rm cscope.files
#}
#
#tx() {
#  tmux splitw "$*; echo -n Press enter to finish.; read"
#  tmux select-layout tiled
#  tmux last-pane
#}
#
#gitzip() {
#  git archive -o $(basename $PWD).zip HEAD
#}
#
#gittgz() {
#  git archive -o $(basename $PWD).tgz HEAD
#}
#
#gitdiffb() {
#  if [ $# -ne 2 ]; then
#    echo two branch names required
#    return
#  fi
#  git log --graph \
#  --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' \
#  --abbrev-commit --date=relative $1..$2
#}
#
##alias gitv='git log --graph --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
#
#miniprompt() {
#  unset PROMPT_COMMAND
#  PS1="\[\e[38;5;168m\]> \[\e[0m\]"
#}
#
#repeat() {
#  local _
#  for _ in $(seq $1); do
#    eval "$2"
#  done
#}
#
#acdul() {
#  acdcli ul -x 8 -r 4 -o "$@"
#}
#
#acddu() {
#  acdcli ls -lbr "$1" | awk '{sum += $3} END { print sum / 1024 / 1024 / 1024 " GB" }'
#}
#
#make-patch() {
#  local name="$(git log --oneline HEAD^.. | awk '{print $2}')"
#  git format-patch HEAD^.. --stdout > "$name.patch"
#}
#
#pbc() {
#  perl -pe 'chomp if eof' | pbcopy
#}
#
#cheap-bin() {
#  local PID=$(jps -lv |
#      fzf --height 30% --reverse --inline-info \
#          --preview 'echo {}' --preview-window bottom:wrap | awk '{print $1}')
#  [ -n "$PID" ] && jmap -dump:format=b,file=cheap.bin $PID
#}
#
#EXTRA=$BASE/bashrc-extra
#[ -f "$EXTRA" ] && source "$EXTRA"
#
#
## boot2docker
## --------------------------------------------------------------------
#if [ "$PLATFORM" = 'Darwin' ]; then
#  dockerinit() {
#    [ $(docker-machine status default) = 'Running' ] || docker-machine start default
#    eval "$(docker-machine env default)"
#  }
#
#  dockerstop() {
#    docker-machine stop default
#  }
#
#  resizes() {
#    mkdir -p out &&
#    for jpg in *.JPG; do
#      echo $jpg
#      [ -e out/$jpg ] || sips -Z 2048 --setProperty formatOptions 80 $jpg --out out/$jpg
#    done
#  }
#
#  j() { export JAVA_HOME=$(/usr/libexec/java_home -v1.$1); }
#
#  # https://gist.github.com/Andrewpk/7558715
#  alias startvpn="sudo launchctl load -w /Library/LaunchDaemons/net.juniper.AccessService.plist; open -a '/Applications/Junos Pulse.app/Contents/Plugins/JamUI/PulseTray.app/Contents/MacOS/PulseTray'"
#  alias quitvpn="osascript -e 'tell application \"PulseTray.app\" to quit';sudo launchctl unload -w /Library/LaunchDaemons/net.juniper.AccessService.plist"
#fi
#
#
## fzf (https://github.com/junegunn/fzf)
## --------------------------------------------------------------------
#
#csi() {
#  echo -en "\x1b[$@"
#}
#
#fzf-down() {
#  fzf --height 50% "$@" --border
#}
#
#export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
#[ -n "$NVIM_LISTEN_ADDRESS" ] && export FZF_DEFAULT_OPTS='--no-height'
#export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
#
#if [ -x ~/.vim/plugged/fzf.vim/bin/preview.rb ]; then
#  export FZF_CTRL_T_OPTS="--preview '~/.vim/plugged/fzf.vim/bin/preview.rb {} | head -200'"
#fi
#
#export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview' --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort' --header 'Press CTRL-Y to copy command into clipboard' --border"
#
#command -v blsd > /dev/null && export FZF_ALT_C_COMMAND='blsd'
#command -v tree > /dev/null && export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
#
## Figlet font selector => copy to clipboard
#fgl() (
#  [ $# -eq 0 ] && return
#  cd /usr/local/Cellar/figlet/*/share/figlet/fonts
#  local font=$(ls *.flf | sort | fzf --no-multi --reverse --preview "figlet -f {} $@") &&
#  figlet -f "$font" "$@" | pbcopy
#)
#
## fco - checkout git branch/tag
#fco() {
#  local tags branches target
#  tags=$(git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
#  branches=$(
#    git branch --all | grep -v HEAD             |
#    sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
#    sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
#  target=$(
#    (echo "$tags"; echo "$branches") | sed '/^$/d' |
#    fzf-down --no-hscroll --reverse --ansi +m -d "\t" -n 2 -q "$*") || return
#  git checkout $(echo "$target" | awk '{print $2}')
#}
#
## fshow - git commit browser
#fshow() {
#  git log --graph --color=always \
#      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
#  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
#      --header "Press CTRL-S to toggle sort" \
#      --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
#                 xargs -I % sh -c 'git show --color=always % | head -200 '" \
#      --bind "enter:execute:echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
#              xargs -I % sh -c 'vim fugitive://\$(git rev-parse --show-toplevel)/.git//% < /dev/tty'"
#}
#
## ftags - search ctags
#ftags() {
#  local line
#  [ -e tags ] &&
#  line=$(
#    awk 'BEGIN { FS="\t" } !/^!/ {print toupper($4)"\t"$1"\t"$2"\t"$3}' tags |
#    cut -c1-$COLUMNS | fzf --nth=2 --tiebreak=begin
#  ) && $EDITOR $(cut -f3 <<< "$line") -c "set nocst" \
#                                      -c "silent tag $(cut -f2 <<< "$line")"
#}
#
## fe [FUZZY PATTERN] - Open the selected file with the default editor
##   - Bypass fuzzy finder if there's only one match (--select-1)
##   - Exit if there's no match (--exit-0)
#fe() {
#  local file
#  file=$(fzf-tmux --query="$1" --select-1 --exit-0)
#  [ -n "$file" ] && ${EDITOR:-vim} "$file"
#}
#
## Modified version where you can press
##   - CTRL-O to open with `open` command,
##   - CTRL-E or Enter key to open with the $EDITOR
#fo() {
#  local out file key
#  IFS=$'\n' read -d '' -r -a out < <(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)
#  key=${out[0]}
#  file=${out[1]}
#  if [ -n "$file" ]; then
#    if [ "$key" = ctrl-o ]; then
#      open "$file"
#    else
#      ${EDITOR:-vim} "$file"
#    fi
#  fi
#}
#
#if [ -n "$TMUX_PANE" ]; then
#  # https://github.com/wellle/tmux-complete.vim
#  fzf_tmux_words() {
#    tmuxwords.rb --all --scroll 500 --min 5 | fzf-down --multi | paste -sd" " -
#  }
#
#  # ftpane - switch pane (@george-b)
#  ftpane() {
#    local panes current_window current_pane target target_window target_pane
#    panes=$(tmux list-panes -s -F '#I:#P - #{pane_current_path} #{pane_current_command}')
#    current_pane=$(tmux display-message -p '#I:#P')
#    current_window=$(tmux display-message -p '#I')
#
#    target=$(echo "$panes" | grep -v "$current_pane" | fzf +m --reverse) || return
#
#    target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')
#    target_pane=$(echo $target | awk 'BEGIN{FS=":|-"} {print$2}' | cut -c 1)
#
#    if [[ $current_window -eq $target_window ]]; then
#      tmux select-pane -t ${target_window}.${target_pane}
#    else
#      tmux select-pane -t ${target_window}.${target_pane} &&
#      tmux select-window -t $target_window
#    fi
#  }
#
#  # Bind CTRL-X-CTRL-T to tmuxwords.sh
#  bind '"\C-x\C-t": "$(fzf_tmux_words)\e\C-e\er"'
#
#elif [ -d ~/github/iTerm2-Color-Schemes/ ]; then
#  ftheme() {
#    local base
#    base=~/github/iTerm2-Color-Schemes
#    $base/tools/preview.rb "$(
#      ls {$base/schemes,~/.vim/plugged/seoul256.vim/iterm2}/*.itermcolors | fzf)"
#  }
#fi
#
## Switch tmux-sessions
#fs() {
#  local session
#  session=$(tmux list-sessions -F "#{session_name}" | \
#    fzf --height 40% --reverse --query="$1" --select-1 --exit-0) &&
#  tmux switch-client -t "$session"
#}
#
## Z integration
##source $BASE/z.sh
##unalias z 2> /dev/null
##z() {
##  [ $# -gt 0 ] && _z "$*" && return
##  cd "$(_z -l 2>&1 | fzf --height 40% --reverse --inline-info +s --tac --query "$*" | sed 's/^[0-9,.]* *//')"
##}
#
## v - open files in ~/.viminfo
#v() {
#  local files
#  files=$(grep '^>' ~/.viminfo | cut -c3- |
#          while read line; do
#            [ -f "${line/\~/$HOME}" ] && echo "$line"
#          done | fzf -d -m -q "$*" -1) && vim ${files//\~/$HOME}
#}
#
## c - browse chrome history
#c() {
#  local cols sep
#  export cols=$(( COLUMNS / 3 ))
#  export sep='{::}'
#
#  cp -f ~/Library/Application\ Support/Google/Chrome/Default/History /tmp/h
#  sqlite3 -separator $sep /tmp/h \
#    "select title, url from urls order by last_visit_time desc" |
#  ruby -ne '
#    cols = ENV["cols"].to_i
#    title, url = $_.split(ENV["sep"])
#    len = 0
#    puts "\x1b[36m" + title.each_char.take_while { |e|
#      if len < cols
#        len += e =~ /\p{Han}|\p{Katakana}|\p{Hiragana}|\p{Hangul}/ ? 2 : 1
#      end
#    }.join + " " * (2 + cols - len) + "\x1b[m" + url' |
#  fzf --ansi --multi --no-hscroll --tiebreak=index |
#  sed 's#.*\(https*://\)#\1#' | xargs open
#}
#
#gemtags() (
#  which ripper-tags || gem install ripper-tags
#  for dir in $(gem env gempath | tr ':' ' '); do
#    if [ -d $dir/gems ]; then
#      cd $dir/gems
#      for d in *; do
#        (cd $d && pwd && ctags -R) &
#      done
#    fi
#  done
#  wait
#)
#
## GIT heart FZF
## -------------
#
#is_in_git_repo() {
#  git rev-parse HEAD > /dev/null 2>&1
#}
#
#g() {
#  if [[ $# > 0 ]]; then
#    git $@
#  else
#    git status -s
#  fi
#}
#
#gf() {
#  is_in_git_repo || return
#  git -c color.status=always status --short |
#  fzf-down -m --ansi --nth 2..,.. \
#    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
#  cut -c4- | sed 's/.* -> //'
#}
#
#gb() {
#  is_in_git_repo || return
#  git branch -a --color=always | grep -v '/HEAD\s' | sort |
#  fzf-down --ansi --multi --tac --preview-window right:70% \
#    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -200' |
#  sed 's/^..//' | cut -d' ' -f1 |
#  sed 's#^remotes/##'
#}
#
#gt() {
#  is_in_git_repo || return
#  git tag --sort -version:refname |
#  fzf-down --multi --preview-window right:70% \
#    --preview 'git show --color=always {} | head -200'
#}
#
#gh() {
#  is_in_git_repo || return
#  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
#  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
#    --header 'Press CTRL-S to toggle sort' \
#    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -200' |
#  grep -o "[a-f0-9]\{7,\}"
#}
#
#gr() {
#  is_in_git_repo || return
#  git remote -v | awk '{print $1 "\t" $2}' | uniq |
#  fzf-down --tac \
#    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
#  cut -d$'\t' -f1
#}
#
#athome() {
#  reset-keyboard
#  ln -s ~/.Xmodmap-das ~/.Xmodmap
#  xmodmap ~/.Xmodmap
#  xrandr --auto --output eDP1 --right-of HDMI2
#}
#
#atmobile() {
#  reset-keyboard
#  cp ~/.Xmodmap-lenovo ~/.Xmodmap
#  xmodmap ~/.Xmodmap
#}
#
#atworkmobile() {
#  reset-keyboard
#  ln -s ~/.Xmodmap-dell ~/.Xmodmap
#}
#
#atwork() {
#  reset-keyboard
#  xrandr --output DP-0 --rotate left
#  xrandr --output DVI-I-1 --rotate normal
#  ln -s ~/.Xmodmap-lolita2 ~/.Xmodmap
#  xmodmap ~/.Xmodmap
#}
#
##bind '"\er": redraw-current-line'
##bind '"\C-g\C-f": "$(gf)\e\C-e\er"'
##bind '"\C-g\C-b": "$(gb)\e\C-e\er"'
##bind '"\C-g\C-t": "$(gt)\e\C-e\er"'
##bind '"\C-g\C-h": "$(gh)\e\C-e\er"'
##bind '"\C-g\C-r": "$(gr)\e\C-e\er"'
#
## source $(brew --prefix)/etc/bash_completion
## source ~/git-completion.bash
## unset _fzf_completion_loaded
## export FZF_TMUX=0
## export FZF_DEFAULT_OPTS='--height 40% --reverse'
## FZF_CTRL_T_OPTS='--height 40% --reverse'
## FZF_CTRL_R_OPTS='--height 40%'
## FZF_ALT_C_OPTS='--height 40% --reverse'
## FZF_COMPLETION_OPTS='--height 40% --reverse'
##source /usr/local/opt/git/etc/bash_completion.d/git-completion.bash
#
#[ -f ~/.fzf.bash ] && source ~/.fzf.bash
#
## ip a
## iwconfig
## ip link set wlan0 up
##Scan for available networks and get network details:
##
##
##$ su
### iwlist scan
##Now edit /etc/network/interfaces. The required configuration is much dependent on your particular setup. See the following example to get an idea of how it works:
##
##
### my wifi device
##auto wlan0
##iface wlan0 inet dhcp
##        wireless-essid [ESSID]
##        wireless-mode [MODE] 
#
## added by Miniconda3 installer
#export PATH="/home/joetoth/miniconda3/bin:$PATH"
