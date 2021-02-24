export PATH=/usr/local/bin:$PATH:$HOME/mdproxy

autoload -U add-zsh-hook

# gcert() {
#  if [[ -n $TMUX ]]; then
#        eval $(tmux show-environment -s)
#  fi
#  command gcert "$@"
#}

# fixup_ssh_auth_sock() {
#   if [[ -n ${SSH_AUTH_SOCK} && ! -e ${SSH_AUTH_SOCK} ]]
#   then
#     local new_sock=$(echo /tmp/ssh-*/agent.*(=UNomY1))
#      if [[ -n ${new_sock} ]]
#      then
#        export SSH_AUTH_SOCK=${new_sock}
#      fi
#   fi
# }
# if [[ -n ${SSH_AUTH_SOCK} ]]
# then
#   add-zsh-hook preexec fixup_ssh_auth_sock
# fi

typeset ssh_environment

function start_ssh_agent() {
	local lifetime
	local -a identities

	zstyle -s :plugins:ssh-agent lifetime lifetime

	ssh-agent -s ${lifetime:+-t} ${lifetime} | sed 's/^echo/#echo/' >! $ssh_environment
	chmod 600 $ssh_environment
	source $ssh_environment > /dev/null

	zstyle -a :plugins:ssh-agent identities identities

	echo starting ssh-agent...
	ssh-add $HOME/.ssh/${^identities}
}

ssh_environment="$HOME/.ssh/environment-$HOST"

if [[ -f "$ssh_environment" ]]; then
	source $ssh_environment > /dev/null
	ps x | grep ssh-agent | grep -q $SSH_AGENT_PID || {
		start_ssh_agent
	}
else
	start_ssh_agent
fi

unset ssh_environment
unfunction start_ssh_agent


# export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

source_if_exists() {
  [[ -s $1 ]] && source $1
}
source_if_exists "$HOME/wdf/work.zsh"

# For work since zplug doesn't like the git version name
export PATH=/usr/git:$PATH

if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

source ~/.zplug/init.zsh

zplugs=() # Reset zplugs
zplug "cdown/clipmenu", use:'*', as:command
zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf, use:"*${(L)$(uname -s)}*amd64*"
zplug "junegunn/fzf", use:"shell/*.zsh", defer:2
zplug "hchbaw/zce.zsh", use:"*.zsh", defer:2
zplug "IngoHeimbach/zsh-easy-motion"
zplug "laktak/extrakto"
zplug "zsh-users/zsh-autosuggestions", use:"zsh-autosuggestions.zsh"
zplug "mafredri/zsh-async", from:"github", use:"async.zsh"
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug "zsh-users/zsh-completions"
zplug "so-fancy/diff-so-fancy", as:command
# starts ssh-agent and sets SSH_AUTH_SOCK
#zplug "bobsoppe/zsh-ssh-agent", use:ssh-agent.zsh, from:github

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load #--verbose

fpath[1,0]=~/.zsh/completion/
fpath=(~/homebrew/share/zsh-completions $fpath)

# Easy Motion in insert and visual mode
bindkey -M vicmd "^Q" zce
bindkey "^Q" zce

export PATH=/usr/local/bin:$PATH:$GOROOT/bin:$GOPATH/bin:$HOME/.local/bin:$HOME/bin:$HOME/opt/go/bin:$HOME/.cargo/bin:$HOME/opt/flutter/bin

## Android
## export ANDROID_HOME=$HOME/opt/android-sdk-linux
## export PATH=$PATH:$ANDROID_HOME/platform-tools
## export PATH=$PATH:$ANDROID_HOME/tools
## export PATH=$PATH:$ANDROID_HOME/build-tools/29.0.3

case `uname` in
  Darwin)
    alias ls='ls -G'

    # Paths for Homebrew
    export HOMEBREW=$HOME/homebrew
    export PATH=$HOMEBREW/sbin:$HOMEBREW/bin:$HOMEBREW/opt:$PATH
    export PATH=$HOMEBREW/bin:$PATH
    export LIBRARY_PATH=$HOMEBREW/lib:$LIBRARY_PATH
    export DYLD_FALLBACK_LIBRARY_PATH=$HOMEBREW/lib
    export C_INCLUDE_PATH=$HOMEBREW/include
    export CPLUS_INCLUDE_PATH=$HOMEBREW/include

    # Python has been installed as
    #   /Users/joetoth/homebrew/opt/python@3.8/bin/python3
    
    # Unversioned symlinks `python`, `python-config`, `pip` etc. pointing to
    # `python3`, `python3-config`, `pip3` etc., respectively, have been installed into
    #   /Users/joetoth/homebrew/opt/python@3.8/libexec/bin
    # You can install Python packages with
    #   /Users/joetoth/homebrew/opt/python@3.8/bin/pip3 install <package>
    # They will install into the site-package directory
    #   /Users/joetoth/homebrew/lib/python3.8/site-packages
 
    # See: https://docs.brew.sh/Homebrew-and-Python
    
    # python@3.8 is keg-only, which means it was not symlinked into /Users/joetoth/homebrew,
    # because this is an alternate version of another formula.
    
    # If you need to have python@3.8 first in your PATH run:
    # export PATH="$HOME/homebrew/opt/python@3.8/bin:$PATH"
    
    # # For compilers to find python@3.8 you may need to set:
    # export LDFLAGS="-L$HOME/homebrew/opt/python@3.8/lib"
    
    # # For pkg-config to find python@3.8 you may need to set:
    # export PKG_CONFIG_PATH="$HOME/homebrew/opt/python@3.8/lib/pkgconfig"
        
    # Vulkan
    # export VULKAN_SDK=$HOME/opt/vulkansdk/macOS
    # export PATH=$VULKAN_SDK/bin:$PATH
    # export DYLD_LIBRARY_PATH=$VULKAN_SDK/lib
    # export VK_LAYER_PATH=$VULKAN_SDK/etc/vulkan/explicit_layer.d
    # export VK_ICD_FILENAMES=$VULKAN_SDK/Applications/vulkaninfo.app/Contents/Resources/vulkan/icd.d/MoltenVK_icd.json
    # Instead cp this file to /etc/vulkan/icd.d/ and edit to remove the leading path and just have
    # the file name.
    fortune
  ;;
  Linux)
    alias ls='ls --color'
    export CPATH="$HOME/opt/cuda-10.0/include:$HOME/opt/cuda-10.0/nvvm/include"
    export LD_LIBRARY_PATH="$HOME/opt/cuda-10.0/lib64:$HOME/opt/cuda-10.0/nvvm/lib64"
    export LIBRARY_PATH="$HOME/opt/cuda-10.0/lib64:$HOME/opt/cuda-10.0/nvvm/lib64"
    export PATH="$HOME/opt/cuda-10.0/bin:$PATH:$HOME/opt/cuda-10.0/nvvm/bin":$VULKAN_SDK/x86_64/bin
    export VULKAN_SDK=$HOME/opt/vulkansdk/macOS
    export PATH="$VULKAN_SDK/x86_64/bin:$PATH"
    /usr/games/fortune
  ;;
esac


export EDITOR='vi'
export VISUAL='vi'
export BROWSER='google-chrome'

export FZF_DEFAULT_OPTS="--extended-exact"
#export _JAVA_AWT_WM_NONREPARENTING=1
export PYTHONSTARTUP="$HOME/bin/python/startup.py"

# Load
#
#------------------------------------------------------------------------------
# VIM
KEYTIMEOUT=10
bindkey -v
bindkey -M vicmd v edit-command-line
autoload edit-command-line; zle -N edit-command-line
autoload -U run-help
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zmodload -i zsh/parameter


## Zsh options
##
##------------------------------------------------------------------------------
##
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.eternal_history
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.

## Auto-suggest
#export COMPLETION_WAITING_DOTS="true"
#export ZSH_AUTOSUGGEST_USE_ASYNC="true"
#bindkey '^ ' autosuggest-accept


# stop control flow, gimme ctrl-s back
bindkey -r '\C-s'
stty -ixon
setopt noflowcontrol

BASE16_THEME=tomorrow-night
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
 
#[ -f "/Users/joetoth/.ghcup/env" ] && source "/Users/joetoth/.ghcup/env" # ghcup-env

## The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/joetoth/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/joetoth/Downloads/google-cloud-sdk/path.zsh.inc'; fi

## The next line enables shell command completion for gcloud.
if [ -f '/Users/joetoth/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/joetoth/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

## Z Style
## ------------------------------------------------------------------------------
#zstyle ':completion::complete:*' use-cache 1
#zstyle ':completion::complete:*' cache-path $ZSH_CACHE

## Enable approximate completions
##zstyle ':completion:*' completer _complete _ignored _approximate
##zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3)) numeric)'
##
### Automatically update PATH entries
##zstyle ':completion:*' rehash true
##
### Use menu completion
##zstyle ':completion:*' menu select
##
### Verbose completion results
##zstyle ':completion:*' verbose true
##
### Smart matching of dashed values, e.g. f-b matching foo-bar
##zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*'
##
### match case-insenstive
##zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
##
### Group results by category
##zstyle ':completion:*' group-name ''
##
### Don't insert a literal tab when trying to complete in an empty buffer
### zstyle ':completion:*' insert-tab false
##
### Keep directories and files separated
##zstyle ':completion:*' list-dirs-first true
##
### Don't try parent path completion if the directories exist
##zstyle ':completion:*' accept-exact-dirs true
##
### Always use menu selection for `cd -`
##zstyle ':completion:*:*:cd:*:directory-stack' force-list always
##zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
##
### Pretty messages during pagination
##zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
##zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
##
### Nicer format for completion messages
##zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
##zstyle ':completion:*:corrections' format '%U%F{green}%d (errors: %e)%f%u'
##zstyle ':completion:*:warnings' format '%F{202}%BSorry, no matches for: %F{214}%d%b'
##
### Show message while waiting for completion
##zstyle ':completion:*' show-completer true
##
### Prettier completion for processes
##zstyle ':completion:*:*:*:*:processes' force-list always
##zstyle ':completion:*:*:*:*:processes' menu yes select
##zstyle ':completion:*:*:*:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
##zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,args -w -w"
##
## Use ls-colors for path completions
#function _set-list-colors() {
#	zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
#	unfunction _set-list-colors
#}
#sched 0 _set-list-colors  # deferred since LC_COLORS might not be available yet
##
## Debian / Ubuntu sets these to vi-up-line-or-history etc,
## which places the cursor at the start of line, not end of line.
## See: http://www.zsh.org/mla/users/2009/msg00878.html
#bindkey -M viins "\e[A" up-line-or-history
#bindkey -M viins "\e[B" down-line-or-history
#bindkey -M viins "\eOA" up-line-or-history
#bindkey -M viins "\eOB" down-line-or-history
#bindkey '^N' up-line-or-search
#bindkey '^P' down-line-or-search

function check_last_exit_code() {
  local LAST_EXIT_CODE=$?
  if [[ $LAST_EXIT_CODE -ne 0 ]]; then
    local EXIT_CODE_PROMPT=' '
    EXIT_CODE_PROMPT+="%{$fg[red]%}-%{$reset_color%}"
    EXIT_CODE_PROMPT+="%{$fg_bold[red]%}$LAST_EXIT_CODE%{$reset_color%}"
    EXIT_CODE_PROMPT+="%{$fg[red]%}-%{$reset_color%}"
    echo "$EXIT_CODE_PROMPT"
  fi
}

RPROMPT='$(check_last_exit_code)'



## ALIASES
## ------------------------------------------------------------------------------
#alias n='vi ~/projects/joetoth.com/content/_researching/_notes.md'
#alias cpg='rsync --progress -rltDvu --modify-window=1'
#alias reset-keyboard='setxkbmap -model pc104 -layout us'
#alias xo='xdg-open'
alias psa="ps aux"
#alias psg="ps aux | grep "
#alias alsg="alias | grep "
#alias cdb='cd -'
alias ll='ls -alh'
alias lt='ls -alhrt'
#alias lss='ls -SlaGh'
alias topdirs='du -x -m . | sort -nr | head -n 100'
#alias lsg='ll | grep'
##alias tmux='tmux -2'
alias debugon='setopt XTRACE VERBOSE'
alias debugoff='unsetopt XTRACE VERBOSE'
#alias gmailc='google-chrome --app="https://mail.google.com/mail/u/0/#inbox?compose=new"'
#alias gmail='google-chrome --app="https://mail.google.com/mail/u/0/#inbox"'
#alias what_port_app='sudo netstat -nlp | grep'
#alias smi='nvidia-smi'

alias pomo='(sleep 1500 && notify-send -u critical "BREAK BREAK BREAK\nBREAK BREAK BREAK\nBREAK BREAK BREAK\nBREAK BREAK BREAK\nBREAK BREAK BREAK")&'
#alias learnd='python $HOME/bin/python/learn.py --daemon=true'
#alias learn-concept='python $HOME/bin/python/learn.py --concept '
#alias learn-printall='python $HOME/bin/python/learn.py --printall=true'
#alias rekall='python $HOME/bin/python/learn.py --rekall=true --concept'
#alias learn-remove='python $HOME/bin/python/learn.py --remove=true --concept'

#alias ve='vim ~/.vimrc'
alias ze='$EDITOR $HOME/.zshrc'
alias zwe='$EDITOR $HOME/wdf/work.zsh'
alias zr='source $HOME/.zshrc'

#alias less='less -r'
#alias tf='tail -f'
#alias l='less'
#alias lh='ls -alt | head' # see the last modified files
#alias cl='clear'
#alias invert-laptop='xrandr --output eDP1 --rotate inverted'
#alias pyserve='python -m SimpleHTTPServer 8000'
#alias ipython='ipython --TerminalInteractiveShell.editing_mode=vi'
#alias ipython3='ipython3 --TerminalInteractiveShell.editing_mode=vi'

## Zippin
#alias gz='tar -zcvf'

#alias touchpadoff='synclient Touchpadoff=1'
#alias touchpadon='synclient Touchpadoff=0'

#alias tfc='rm -rf /tmp/tf'

#alias clipster-daemon='clipster -f ~/clipster.ini -d'
#alias lock='xscreensaver-command -lock'
#alias battery='upower -i $(upower -e | grep 'BAT') | grep -E "state|to\ full|percentage"'
alias cdp='cd ~/projects'
alias cdm='cd ~/projects/joetoth.com'
alias vpn='sudo openvpn --config $HOME/vpn/1.ovpn --auth-user-pass $HOME/ovpn.txt'
alias vpn2='sudo openvpn --config $HOME/vpn/2.ovpn --auth-user-pass $HOME/ovpn.txt'
alias vpn3='sudo openvpn --config $HOME/vpn/3.ovpn --auth-user-pass $HOME/ovpn.txt'
alias large_files_in_home='find ~/ -xdev -type f -size +100M'

## FUNCTIONS

## PATH for the Google Cloud SDK and completion
#source_if_exists $HOME/opt/google-cloud-sdk/path.zsh.inc
#source_if_exists $HOME/opt/google-cloud-sdk/completion.zsh.inc 


## OPAM configuration
#source_if_exists $HOME/.opam/opam-init/init.zsh
#source_if_exists $HOME/bazel.zsh

tb() {
  tensorboard --logdir "$@"
}
## GIT
##
#git_log_defaults="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%<(70,trunc)%s %Creset%<(15,trunc)%cn%C(auto)%d"

#__git_files () {
#    _wanted files expl 'local files' _files
#}

## No arguments: `git status -s`
## With arguments: acts like `git`
compdef g=git

g() {
  if [[ $# > 0 ]]; then
    git $@
  else
    git status -s
  fi
}


alias gac='git commit -a -m'
#alias gco='git checkout'
#alias git-magic-rebase='git rebase --onto work $(git5 status --base) $(git rev-parse --abbrev-ref HEAD)'
#alias gn='git diff --name-only --relative | uniq'
#alias glg="git log --graph --decorate --all --pretty='$git_log_defaults'"
#alias grc='git add -A && git rebase --continue'
#alias gaa='git add -A'
#alias gs='git stash'
#alias gsp='git stash pop'


## Mercurial
## No arguments: `hg xl`
## With arguments: acts like `hg`
alias hg='chg'
compdef h=hg

h() {
  if [[ $# > 0 ]]; then
    hg $@
  else
    hg xl
  fi
}

#alias hgc='hg commit'
#alias hgb='hg branch'
#alias hgba='hg branches'
#alias hgbk='hg bookmarks'
#alias hgco='hg checkout'
#alias hgd='hg diff'
#alias hged='hg diffmerge'
## pull and update
#alias hgi='hg incoming'
#alias hgl='hg pull -u'
#alias hglr='hg pull --rebase'
#alias hgo='hg outgoing'
#alias hgp='hg push'
#alias hgs='hg status'
#alias hgsl='hg log --limit 20 --template "{node|short} | {date|isodatesec} | {author|user}: {desc|strip|firstline}\n" '
## this is the 'git commit --amend' equivalent
#alias hgca='hg qimport -r tip ; hg qrefresh -e ; hg qfinish tip'
## list unresolved files (since hg does not list unmerged files in the status command)
#alias hgun='hg resolve --list'

alias hs='hg status'
alias u='hg uploadchain'
alias ua='hg uploadall'


#function lvar() {
#  lvar=$(</dev/stdin)
##  lvar=$(echo $lvar | tr "\\n" " ")
#  export lvar
#}

#function javatests() {
#  javatests=$(</dev/stdin)
#  javatests=$(echo $javatests | grep -oh -P "(//java.+?\s)")
#  export javatests
#}

#function athome() {
#  reset-keyboard
#  ln -s ~/.Xmodmap-das ~/.Xmodmap
#  xmodmap ~/.Xmodmap
#  xrandr --auto --output eDP1 --right-of HDMI2
#}

#function atmobile() {
#  reset-keyboard
#  cp ~/.Xmodmap-lenovo ~/.Xmodmap
#  xmodmap ~/.Xmodmap
#}

#function atworkmobile() {
#  reset-keyboard
#  ln -s ~/.Xmodmap-dell ~/.Xmodmap
#}

#function atwork() {
#  reset-keyboard
#  xrandr --output DP-0 --rotate left
#  xrandr --output DVI-I-1 --rotate normal
#  ln -s ~/.Xmodmap-lolita2 ~/.Xmodmap
#  xmodmap ~/.Xmodmap
#}

#function du-size() {
# du -a $1 | sort -n -r | head -n 100
#}

#function goog() {
#  google-chrome "-app=http://google.com/#q=$@"
#}

#function writecmd() {
#    perl -e '$TIOCSTI = 0x5412; $l = <STDIN>; $lc = $ARGV[0] eq "-run" ? "\n" : ""; $l =~ s/\s*$/$lc/; map { ioctl STDOUT, $TIOCSTI, $_; } split "", $l;' -- $1
#}

## Remove Bluelight
#night_mode() {
#    for disp in $(xrandr | sed -n 's/^\([^ ]*\).*\<connected\>.*/\1/p'); do
#        xrandr --output $disp --gamma $1 --brightness $2
#    done
#}
#alias bluelight_on='night_mode 1:1:1   1.0'
#alias bluelight_off='night_mode 1:1:0.7   1.0'
 
## fhe - repeat history edit
##fhe() {
##  ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -re 's/^\s*[0-9]+\s*//' 
##}
##
##
#edit_file_in_directory() {
#  local file files
#  files=$(ls $1) &&
#  file=$(echo "$files" | fzf +m) &&
#  $EDITOR $1/$file
#}

#pe() {
#  edit_file_in_directory "$MY_PYTHON_BIN"
#}

##cd into the directory of the selected file
#cdf() {
#   local file
#   local dir
#   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
#}
  
#qq() {
#  tmux capture-pane -J -S -10 -p >| /tmp/tmux-pane-buffer
#  local cmd="cat /home/joetoth/projects/ejt/test.txt"
#  eval "$cmd" | /home/joetoth/bin/ejt | while read item; do
#    printf '%q ' "$item"
#  done
#  echo                                 
#}

#tmux-append-paste() {
#  tmux send-keys "y" && tmux send-keys "Y"
#}

#dev() {
#  while inotifywait -e modify -e create -e delete $1; do
#		echo "$2"
#		eval "$2"
#  done
#}

#record_changes() {
#	while true; do 
#    filename=$(inotifywait -e close_write -r -q --format %w%f $1)
#		echo "$filename"
#  done
#}


#c() {
#  local cols sep
#  cols=$(( COLUMNS / 3 ))
#  sep='{{::}}'
#  jq -r '.roots[] | recurse(.children[]?) | select(.type != "folder") | {name, url} | join("'$sep'") | . ' < ~/.config/google-chrome/Default/Bookmarks | head -n-1 |
#  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\n", $1, $2}' |
#  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs -I {} google-chrome -app={}
#}

## http://askubuntu.com/questions/624120/is-it-possible-to-view-google-chrome-bookmarks-and-history-from-the-terminal
## c - browse chrome history
#ch() {
#  local cols sep
#  cols=$(( COLUMNS / 3 ))
#  sep='{{::}}'

#  # Copy History DB to circumvent the lock
#  # - See http://stackoverflow.com/questions/8936878 for the file path
#  cp -f ~/.config/google-chrome/Default/History /tmp/h

#  sqlite3 -separator $sep /tmp/h \
#    "select substr(title, 1, $cols), url
#     from urls order by last_visit_time desc" |
#  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\n", $1, $2}' |
#  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs open
#}

#fkill() {
#  pid=$(ps -ef | sed 1d | fzf -m -e | awk '{print $2}')

#  if [ "x$pid" != "x" ]
#  then
#    kill -${1:-9} $pid
#  fi
#}

#fport() {
#  pid=$(lsof -P | fzf -e | awk '{print $2}')
#  if [ "x$pid" != "x" ]
#  then
#    kill -${1:-9} $pid
#  fi
#}


#alias enc_dir='tar -czf - * | openssl enc -e -pbkdf2 -out'
#unenc () {
#  openssl enc -d -pbkdf2 -in $1 | tar xz --one-top-level=$2
#}



#### WIDGETS
##
# CTRL-F - 
__find() {
  local cmd="rg \"\""
  eval "$cmd" | $(__fzfcmd) --ansi -m | while read item; do
    printf '%q ' "$item"
  done
  echo
}

fzf-find-widget() {
  LBUFFER="${LBUFFER}$(__find)"
  zle redisplay
}
zle     -N   fzf-find-widget
bindkey '^F' fzf-find-widget

# CTRL-U - Select user
#__user() {
#  local cmd="cat $HOME/users.csv"
#  eval "$cmd" | $(__fzfcmd) --ansi -m | while read item; do
#    printf '%q ' "$item"
#  done
#  echo
#}
#
#fzf-user-widget() {
#  LBUFFER="${LBUFFER}$(__user)"
#  zle redisplay
#}
#zle     -N   fzf-user-widget
#bindkey '^U' fzf-user-widget

## CTRL-B - Select from clipboard history
#__clipster() {
#  local cmd="clipster -o -n 1000"
#  eval "$cmd" | $(__fzfcmd) -m --ansi | while read item; do
#    printf '%q ' "$item"
#  done
#  echo
#}

#fzf-clipster-widget() {
#  LBUFFER="${LBUFFER}$(__clipster)"
#  zle redisplay
#}
#zle     -N   fzf-clipster-widget
#bindkey '^B' fzf-clipster-widget


## CTRL-O - Enter copy mode and prompt to search backwards.
#__tmux-copy() {
#  tmux copy-mode && tmux send-keys "?"
#  echo
#}

#tmux-copy-widget() {
#  LBUFFER="${LBUFFER}$(__tmux-copy)"
#  zle redisplay
#}
#zle     -N   tmux-copy-widget
#bindkey '^O' tmux-copy-widget




########## Initialize completion

autoload -Uz compinit

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

## Also here to override aliases
#source_if_exists $HOME/wdf/work.zsh



## INFO =================================
## Kill app on port
## fuser -k 2222/tcp

## Battery
## upower -i $(upower -e | grep 'BAT') | grep -E "state|to\ full|percentage"
## Wireless commands
## iw dev
## ip link set wlan0 up  
## ip link wlan0 show
## iw wlan0 scan
## Add wireless network
## wpa_passphrase gorilla >> /etc/wpa_supplicant.conf 
## ...type in the passphrase and hit enter...
##
## wpa_supplicant -B -D wext -i wlan0 -c /etc/wpa_supplicant.conf
## dhclient wlan0
## edit /etc/network/interfaces and add wpa/psk
##
## Network Manager Command Line
## nmcli c up id joetoth.com
## nmcli dev wifi con "myssid" password "myssidpassword"
##
## You can also get a list of available access points with:
##
## nmcli dev wifi list
## List Libaries
## /sbin/ldconfig -p


## JUNK >.....
##
##__termjt() {
##  tmux -c "/usr/bin/python3 ~/bin/python/sel.py"
##  f="/tmp/termjt"
##  echo "" >! $f
##  tmux capture-pane -J -S 0 -p >| /tmp/tmux-pane-buffer
##  cat /tmp/tmux-pane-buffer | sed 's/[ \t]*$//' | tmux -c "termjt -regexp '(?m)\S{12,}|\d{4,10}' -outputFilename $f" 3>&1 1>&2 
##  ##termjt -outputFilename $f
##  value=$(cat $f) 
##  echo "$value"
##}
##
##termjt-screen-widget() {
##  #LBUFFER="${LBUFFER}$(__termjt)"
##  tmux -c "/usr/bin/python3 ~/bin/python/sel.py"
##  zle redisplay
##}
##zle     -N   termjt-screen-widget
##bindkey '^S' 'termjt-screen-widget'

[[ -e /Users/joetoth/mdproxy/data/mdproxy_zshrc ]] && source /Users/joetoth/mdproxy/data/mdproxy_zshrc # MDPROXY-ZSHRC

