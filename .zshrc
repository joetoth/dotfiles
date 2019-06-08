# Set up the prompt
#xonsh
#exit
#
#
export PATH=/usr/git:$PATH

if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

source ~/.zplug/init.zsh

zplugs=() # Reset zplugs

zplug "cdown/clipmenu", as:command
zplug "junegunn/fzf-bin", from:gh-r, as:command, rename-to:fzf, use:"*${(L)$(uname -s)}*amd64*"
zplug "junegunn/fzf", use:"shell/*.zsh", defer:2
zplug "IngoHeimbach/zsh-easy-motion"
zplug "Morantron/tmux-fingers"
zplug "zsh-users/zsh-autosuggestions", use:"zsh-autosuggestions.zsh"
zplug "mafredri/zsh-async", from:"github", use:"async.zsh"
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug "zsh-users/zsh-completions"
zplug "so-fancy/diff-so-fancy", as:command
# ga, glo, gi, gd, gcf, gss, gclean, 
zplug "wfxr/forgit", defer:1
zplug "bobsoppe/zsh-ssh-agent", use:ssh-agent.zsh, from:github

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load #--verbose
fpath[1,0]=~/.zsh/completion/
#fpath=(~/homebrew/share/zsh-completions $fpath)


export GOPATH=$HOME/projects/go
export PATH=/usr/local/bin:$PATH:$GOROOT/bin:$GOPATH/bin:$HOME/.local/bin:$HOME/bin:$HOME/opt/go/bin:$HOME/.cargo/bin

export FILAMENT_SDK=$HOME/opt/filament
export PATH="$FILAMENT_SDK/bin:$PATH"

export VULKAN_SDK=$HOME/opt/vulkan-sdk
export VK_LAYER_PATH="$VULKAN_SDK/x86_64/etc/explicit_layer.d"
export PATH="$VULKAN_SDK/x86_64/bin:$PATH"


export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$HOME/opt/maven/bin:$HOME/opt/google-cloud-sdk/bin
export PATH=$PATH:$MY_PYTHON_BIN

case `uname` in
  Darwin)
    
    # Paths for Homebrew
    export PATH=$HOME/homebrew/bin:$PATH:$HOME/Library/Python/3.7/bin
    export PATH=$HOME/opt/nvim/bin:$PATH
    #export PATH="$HOME/homebrew/opt/bison/bin:$PATH"
    ## coreutils must be installed for gnu ls
    #export PATH="$HOME/homebrew/opt/coreutils/libexec/gnubin:$PATH"
    #export CXXFLAGS="-I$HOME/homebrew/include, -I$HOME/homebrew/opt/llvm/include, -I$HOME/homebrew/opt/llvm/include/c++/v1"
    #export CFLAGS="$CXXFLAGS"
    #export LDFLAGS="-L$HOME/homebrew/opt/llvm/lib -Wl,-rpath,$HOME/homebrew/opt/llvm/lib"
    #
    export PATH=$PATH:$VULKAN_SDK/macOS/bin
    export DYLD_LIBRARY_PATH=$VULKAN_SDK/macOS/lib
    export VK_LAYER_PATH=$VULKAN_SDK/macOS/etc/vulkan/explicit_layers.d
    export VK_ICD_FILENAMES=$VULKAN_SDK/etc/vulkan/icd.d/MoltenVK_icd.json
    export VULKAN_SDK=$HOME/opt/vulkansdk/macOS/


    fortune
  ;;
  Linux)
    alias ls='ls --color'
    export CPATH="$HOME/opt/cuda-10.0/include:$HOME/opt/cuda-10.0/nvvm/include"
    export LD_LIBRARY_PATH="$HOME/opt/cuda-10.0/lib64:$HOME/opt/cuda-10.0/nvvm/lib64"
    export LIBRARY_PATH="$HOME/opt/cuda-10.0/lib64:$HOME/opt/cuda-10.0/nvvm/lib64"
    export PATH="$HOME/opt/cuda-10.0/bin:$PATH:$HOME/opt/cuda-10.0/nvvm/bin":$VULKAN_SDK/x86_64/bin
    /usr/games/fortune
  ;;
  FreeBSD)
  ;;
esac


export EDITOR='vi'
export VISUAL='vi'
export BROWSER=google-chrome
export ANDROID_HOME=$HOME/opt/android-sdk-linux
export R_LIBS=$HOME/rlibs
export FZF_DEFAULT_OPTS="--extended-exact"
export FZF_DEFAULT_COMMAND='rg ""'
## To apply the command to CTRL-T as well
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export CLOUDSDK_COMPUTE_ZONE="us-east1-b"
export MY_PYTHON_BIN="$HOME/bin/python"
export PYTHONIOENCODING="utf-8"
export _JAVA_AWT_WM_NONREPARENTING=1
export PYTHONSTARTUP="$HOME/bin/python/startup.py"

# Load
#
#------------------------------------------------------------------------------
autoload -U run-help
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zmodload -i zsh/parameter


# Zsh options
#
#------------------------------------------------------------------------------
#
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
#setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# Auto-suggest
export COMPLETION_WAITING_DOTS="true"
export ZSH_AUTOSUGGEST_USE_ASYNC="true"
bindkey '^ ' autosuggest-accept

# VIM
bindkey -v
bindkey -M vicmd v edit-command-line
autoload edit-command-line; zle -N edit-command-line

KEYTIMEOUT=10

# stop control flow, gimme ctrl-s back
bindkey -r '\C-s'
stty -ixon
setopt noflowcontrol


# Z Style
# ------------------------------------------------------------------------------
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path $ZSH_CACHE

# Enable approximate completions
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3)) numeric)'

# Automatically update PATH entries
zstyle ':completion:*' rehash true

# Use menu completion
zstyle ':completion:*' menu select

# Verbose completion results
zstyle ':completion:*' verbose true

# Smart matching of dashed values, e.g. f-b matching foo-bar
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*'

# match case-insenstive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Group results by category
zstyle ':completion:*' group-name ''

# Don't insert a literal tab when trying to complete in an empty buffer
# zstyle ':completion:*' insert-tab false

# Keep directories and files separated
zstyle ':completion:*' list-dirs-first true

# Don't try parent path completion if the directories exist
zstyle ':completion:*' accept-exact-dirs true

# Always use menu selection for `cd -`
zstyle ':completion:*:*:cd:*:directory-stack' force-list always
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select

# Pretty messages during pagination
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# Nicer format for completion messages
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:corrections' format '%U%F{green}%d (errors: %e)%f%u'
zstyle ':completion:*:warnings' format '%F{202}%BSorry, no matches for: %F{214}%d%b'

# Show message while waiting for completion
zstyle ':completion:*' show-completer true

# Prettier completion for processes
zstyle ':completion:*:*:*:*:processes' force-list always
zstyle ':completion:*:*:*:*:processes' menu yes select
zstyle ':completion:*:*:*:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,args -w -w"

# Use ls-colors for path completions
function _set-list-colors() {
	zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
	unfunction _set-list-colors
}
sched 0 _set-list-colors  # deferred since LC_COLORS might not be available yet

# Don't complete hosts from /etc/hosts
zstyle -e ':completion:*' hosts 'reply=()'

# Don't complete uninteresting stuff unless we really want to.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec)|TRAP*)'
zstyle ':completion:*:*:*:users' ignored-patterns \
		adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
		clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
		gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
		ldap lp mail mailman mailnull man messagebus mldonkey mysql nagios \
		named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
		operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
		rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
		usbmux uucp vcsa wwwrun xfs cron mongodb nullmail portage redis \
		shoutcast tcpdump '_*'
zstyle ':completion:*' single-ignored show

#
# Debian / Ubuntu sets these to vi-up-line-or-history etc,
# which places the cursor at the start of line, not end of line.
# See: http://www.zsh.org/mla/users/2009/msg00878.html
bindkey -M viins "\e[A" up-line-or-history
bindkey -M viins "\e[B" down-line-or-history
bindkey -M viins "\eOA" up-line-or-history
bindkey -M viins "\eOB" down-line-or-history
bindkey '^N' up-line-or-search
bindkey '^P' down-line-or-search
#bindkey -M viins 'jj' vi-cmd-mode

# gruvbox theme
dark0_hard="#1D2021"
dark0="#282828"
dark0_soft="#32302F"
dark1="#3c3836"
dark2="#504945"
dark3="#665c54"
dark4="#7C6F64"

gray_245="#928374"
gray_244="#928374"

light0_hard="#FB4934"
light0="#FBF1C7"
light0_soft="#F2E5BC"
light1="#EBDBB2"
light2="#D5C4A1"
light3="#BDAE93"
light4="#A89984"

bright_red="#FB4934"
bright_green="#B8BB26"
bright_yellow="#FABD2F"
bright_blue="#83A598"
bright_purple="#D3869B"
bright_aqua="#8EC07C"
bright_orange="#FE8019"

neutral_red="#CC241D"
neutral_green="#98971A"
neutral_yellow="#D79921"
neutral_blue="#458588"
neutral_purple="#B16286"
neutral_aqua="#689D6A"
neutral_orange="#D65D0E"

faded_red="#9D0006"
faded_green="#79740E"
faded_yellow="#B57614"
faded_blue="#076678"
faded_purple="#8F3F71"
faded_aqua="#427B58"
faded_orange="#AF3A03"

# Predictable SSH authentication socket location.
#alias fixssh='eval $(tmux showenv -s SSH_AUTH_SOCK)'
#eval $(tmux showenv -s SSH_AUTH_SOCK)
#SOCK="/tmp/ssh-agent.sock"
#if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ]
#then
#    rm -f /tmp/ssh-agent.sock
#    ln -sf $SSH_AUTH_SOCK $SOCK
#    export SSH_AUTH_SOCK=$SOCK
#fi

bindkey "^Xz" zce




# ALIASES
# ------------------------------------------------------------------------------
alias note='vi ~/drive/note.txt'
alias cpg='rsync --progress -rltDvu --modify-window=1'
alias reset-keyboard='setxkbmap -model pc104 -layout us'
alias xo='xdg-open'
alias psa="ps aux"
alias psg="ps aux | grep "
alias alsg="alias | grep "
alias cdb='cd -'
alias ll='ls -alh'
alias lt='ls -alhrt'
alias lss='ls -SlaGh'
alias topdirs='du -x -m . | sort -nr | head -n 100'
alias lsg='ll | grep'
#alias tmux='tmux -2'
alias debugon='setopt XTRACE VERBOSE'
alias debugoff='unsetopt XTRACE VERBOSE'
alias gmailc='google-chrome --app="https://mail.google.com/mail/u/0/#inbox?compose=new"'
alias gmail='google-chrome --app="https://mail.google.com/mail/u/0/#inbox"'
alias what_port_app='sudo netstat -nlp | grep'
alias smi='nvidia-smi'

alias pomo='(sleep 1500 && notify-send -u critical "BREAK BREAK BREAK\nBREAK BREAK BREAK\nBREAK BREAK BREAK\nBREAK BREAK BREAK\nBREAK BREAK BREAK")&'
alias learnd='python $HOME/bin/python/learn.py --daemon=true'
alias learn-concept='python $HOME/bin/python/learn.py --concept '
alias learn-printall='python $HOME/bin/python/learn.py --printall=true'
alias rekall='python $HOME/bin/python/learn.py --rekall=true --concept'
alias learn-remove='python $HOME/bin/python/learn.py --remove=true --concept'

alias ve='vim ~/.vimrc'
alias ze='$EDITOR $HOME/.zshrc'
alias zwe='$EDITOR $HOME/wdf/work.zsh'
alias zr='source $HOME/.zshrc'

alias less='less -r'
alias tf='tail -f'
alias l='less'
alias lh='ls -alt | head' # see the last modified files
alias cl='clear'
alias invert-laptop='xrandr --output eDP1 --rotate inverted'
alias pyserve='python -m SimpleHTTPServer 8000'
alias ipython3='ipython3 --TerminalInteractiveShell.editing_mode=vi'

# Zippin
alias gz='tar -zcvf'

alias touchpadoff='synclient Touchpadoff=1'
alias touchpadon='synclient Touchpadoff=0'

# create __init__.py files in every directory, allowing Intellj to treat each directory as a python module and now all imports will work.
alias python_add_init="find . -type d -exec touch '{}/__init__.py' \;"
alias tfc='rm -rf /tmp/tf'
#alias tb='tensorboard --logdir=/tmp/tf'

alias clipster-daemon='clipster -f ~/clipster.ini -d'
alias lock='xscreensaver-command -lock'
alias battery='upower -i $(upower -e | grep 'BAT') | grep -E "state|to\ full|percentage"'
alias cdp='cd ~/projects'
alias cda='cd ~/projects/psycho'
alias vpn='sudo openvpn --config $HOME/vpn/1.ovpn --auth-user-pass $HOME/ovpn.txt'
alias vpn2='sudo openvpn --config $HOME/vpn/2.ovpn --auth-user-pass $HOME/ovpn.txt'
alias vpn3='sudo openvpn --config $HOME/vpn/3.ovpn --auth-user-pass $HOME/ovpn.txt'
alias blog='vi ~/projects/joe.ai/content/'

# FUNCTIONS
source_if_exists() {
  [[ -s $1 ]] && source $1
}

# PATH for the Google Cloud SDK and completion
source_if_exists $HOME/opt/google-cloud-sdk/path.zsh.inc
source_if_exists $HOME/opt/google-cloud-sdk/completion.zsh.inc 


# OPAM configuration
source_if_exists $HOME/.opam/opam-init/init.zsh
source_if_exists $HOME/bazel.zsh

# GIT
#
git_log_defaults="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%<(70,trunc)%s %Creset%<(15,trunc)%cn%C(auto)%d"

__git_files () {
    _wanted files expl 'local files' _files
}

# No arguments: `git status -s`
# With arguments: acts like `git`
compdef g=git

g() {
  if [[ $# > 0 ]]; then
    git $@
  else
    git status -s
  fi
}

gl() {
  LINES=20
  if [ $1 ]; then
    LINES=$1
  fi
  git log --decorate --all --pretty="$git_log_defaults" "-$LINES"
}

glb() {
  LINES=20
  if [ $1 ]; then
    LINES=$1
  fi
  git log --decorate --pretty="$git_log_defaults" "-$LINES"
}

git-mini-log() {
  git log --pretty=format:"%C(3)%h%C(5) %<(8,trunc)%an %C(10)%ad %Creset%<(50,trunc)%s" --date=format:%d/%m/%y "$@"
}

tb() {
  tensorboard --logdir "$@"
}

gc() {
  if [[ $@ == "-vp" ]]; then
    clear && git commit -vp
  else
    git commit "$@"
  fi
}

D() {
  if test "$#" = 0; then
    (
      git diff --color | diff-so-fancy
      git ls-files --others --exclude-standard | while read -r i; do git diff --color -- /dev/null "$i" | diff-so-fancy; done
    ) | less -R
  else
    git diff "$@"
  fi
}

d() {
  git diff 
}

alias gac='git commit -a -m'
alias gco='git checkout'
alias git-magic-rebase='git rebase --onto work $(git5 status --base) $(git rev-parse --abbrev-ref HEAD)'
alias gn='git diff --name-only --relative | uniq'
alias glg="git log --graph --decorate --all --pretty='$git_log_defaults'"
alias grc='git add -A && git rebase --continue'
alias gaa='git add -A'
alias gs='git stash'
alias gsp='git stash pop'


# No arguments: `hg xl`
# With arguments: acts like `hg`
compdef h=hg

h() {
  if [[ $# > 0 ]]; then
    hg $@
  else
    hg status
    hg xl
  fi
}

gl() {
  LINES=20
  if [ $1 ]; then
    LINES=$1
  fi
  git log --decorate --all --pretty="$git_log_defaults" "-$LINES"
}

glb() {
  LINES=20
  if [ $1 ]; then
    LINES=$1
  fi
  git log --decorate --pretty="$git_log_defaults" "-$LINES"
}

git-mini-log() {
  git log --pretty=format:"%C(3)%h%C(5) %<(8,trunc)%an %C(10)%ad %Creset%<(50,trunc)%s" --date=format:%d/%m/%y "$@"
}

tb() {
  tensorboard --logdir "$@"
}

gc() {
  if [[ $@ == "-vp" ]]; then
    clear && git commit -vp
  else
    git commit "$@"
  fi
}

D() {
  if test "$#" = 0; then
    (
      git diff --color | diff-so-fancy
      git ls-files --others --exclude-standard | while read -r i; do git diff --color -- /dev/null "$i" | diff-so-fancy; done
    ) | less -R
  else
    git diff "$@"
  fi
}



# Mercurial
alias hgc='hg commit'
alias hgb='hg branch'
alias hgba='hg branches'
alias hgbk='hg bookmarks'
alias hgco='hg checkout'
alias hgd='hg diff'
alias hged='hg diffmerge'
# pull and update
alias hgi='hg incoming'
alias hgl='hg pull -u'
alias hglr='hg pull --rebase'
alias hgo='hg outgoing'
alias hgp='hg push'
alias hgs='hg status'
alias hgsl='hg log --limit 20 --template "{node|short} | {date|isodatesec} | {author|user}: {desc|strip|firstline}\n" '
# this is the 'git commit --amend' equivalent
alias hgca='hg qimport -r tip ; hg qrefresh -e ; hg qfinish tip'
# list unresolved files (since hg does not list unmerged files in the status command)
alias hgun='hg resolve --list'

alias u='hg uploadchain'


d() {
  git diff 
}

function lvar() {
  lvar=$(</dev/stdin)
#  lvar=$(echo $lvar | tr "\\n" " ")
  export lvar
}

function javatests() {
  javatests=$(</dev/stdin)
  javatests=$(echo $javatests | grep -oh -P "(//java.+?\s)")
  export javatests
}

function athome() {
  reset-keyboard
  ln -s ~/.Xmodmap-das ~/.Xmodmap
  xmodmap ~/.Xmodmap
  xrandr --auto --output eDP1 --right-of HDMI2
}

function atmobile() {
  reset-keyboard
  cp ~/.Xmodmap-lenovo ~/.Xmodmap
  xmodmap ~/.Xmodmap
}

function atworkmobile() {
  reset-keyboard
  ln -s ~/.Xmodmap-dell ~/.Xmodmap
}

function atwork() {
  reset-keyboard
  xrandr --output DP-0 --rotate left
  xrandr --output DVI-I-1 --rotate normal
  ln -s ~/.Xmodmap-lolita2 ~/.Xmodmap
  xmodmap ~/.Xmodmap
}

function du-size() {
 du -a $1 | sort -n -r | head -n 100
}

function goog() {
  google-chrome "-app=http://google.com/#q=$@"
}

function writecmd() {
    perl -e '$TIOCSTI = 0x5412; $l = <STDIN>; $lc = $ARGV[0] eq "-run" ? "\n" : ""; $l =~ s/\s*$/$lc/; map { ioctl STDOUT, $TIOCSTI, $_; } split "", $l;' -- $1
}

function x() {
print -s "$@"
}

# Remove Bluelight
night_mode() {
    for disp in $(xrandr | sed -n 's/^\([^ ]*\).*\<connected\>.*/\1/p'); do
        xrandr --output $disp --gamma $1 --brightness $2
    done
}

alias bluelight_on='night_mode 1:1:1   1.0'
alias bluelight_off='night_mode 1:1:0.7   1.0'
 
# fhe - repeat history edit
#fhe() {
#  ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -re 's/^\s*[0-9]+\s*//' 
#}
#
#
edit_file_in_directory() {
  local file files
  files=$(ls $1) &&
  file=$(echo "$files" | fzf +m) &&
  $EDITOR $1/$file
}

pe() {
  edit_file_in_directory "$MY_PYTHON_BIN"
}

#cd into the directory of the selected file
cdf() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}
  
qq() {
  tmux capture-pane -J -S -10 -p >| /tmp/tmux-pane-buffer
  local cmd="cat /home/joetoth/projects/ejt/test.txt"
  eval "$cmd" | /home/joetoth/bin/ejt | while read item; do
    printf '%q ' "$item"
  done
  echo                                 
}

tmux-append-paste() {
  tmux send-keys "y" && tmux send-keys "Y"
}

dev() {
  while inotifywait -e modify -e create -e delete $1; do
		echo "$2"
		eval "$2"
  done
}

record_changes() {
	while true; do 
    filename=$(inotifywait -e close_write -r -q --format %w%f $1)
		echo "$filename"
  done
}

# fbr - checkout git branch
fbr() {
  local branches branch
  branches=$(git branch) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | sed "s/.* //")
}

# fco - checkout git branch/tag
fco() {
  local tags branches target
  tags=$(
    git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
    git branch --all | grep -v HEAD             |
    sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
    sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$tags"; echo "$branches") |
    fzf-tmux -l30 -- --no-hscroll --ansi +m -d "\t" -n 2) || return
  git checkout $(echo "$target" | awk '{print $2}')
}
# fcoc - checkout git commit
fcoc() {
  local commits commit
  commits=$(git log --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e) &&
  git checkout $(echo "$commit" | sed "s/ .*//")
}
# fshow - git commit browser
fshow() {
  local out sha q
  while out=$(
      git log --decorate=short --graph --oneline --color=always |
      fzf --ansi --multi --no-sort --reverse --query="$q" --print-query); do
    q=$(head -1 <<< "$out")
    while read sha; do
      [ -n "$sha" ] && git show --color=always $sha | less -R
    done < <(sed '1d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
  done
}
# fcs - get git commit sha
# example usage: git rebase -i `fcs`
fcs() {
  local commits commit
  commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
  commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
  echo -n $(echo "$commit" | sed "s/ .*//")
}
# fstash - easier way to deal with stashes
# type fstash to get a list of your stashes
# enter shows you the contents of the stash
# ctrl-d shows a diff of the stash against your current HEAD
# ctrl-b checks the stash out as a branch, for easier merging
fstash() {
  local out q k sha
    while out=$(
      git stash list --pretty="%C(yellow)%h %>(14)%Cgreen%cr %C(blue)%gs" |
      fzf --ansi --no-sort --query="$q" --print-query \
          --expect=ctrl-d,ctrl-b);
    do
      q=$(head -1 <<< "$out")
      k=$(head -2 <<< "$out" | tail -1)
      sha=$(tail -1 <<< "$out" | cut -d' ' -f1)
      [ -z "$sha" ] && continue
      if [ "$k" = 'ctrl-d' ]; then
        git diff $sha
      elif [ "$k" = 'ctrl-b' ]; then
        git stash branch "stash-$sha" $sha
        break;
      else
        git stash show -p $sha
      fi
    done
}

c() {
  local cols sep
  cols=$(( COLUMNS / 3 ))
  sep='{{::}}'
  jq -r '.roots[] | recurse(.children[]?) | select(.type != "folder") | {name, url} | join("'$sep'") | . ' < ~/.config/google-chrome/Default/Bookmarks | head -n-1 |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs -I {} google-chrome -app={}
}

# http://askubuntu.com/questions/624120/is-it-possible-to-view-google-chrome-bookmarks-and-history-from-the-terminal
# c - browse chrome history
ch() {
  local cols sep
  cols=$(( COLUMNS / 3 ))
  sep='{{::}}'

  # Copy History DB to circumvent the lock
  # - See http://stackoverflow.com/questions/8936878 for the file path
  cp -f ~/.config/google-chrome/Default/History /tmp/h

  sqlite3 -separator $sep /tmp/h \
    "select substr(title, 1, $cols), url
     from urls order by last_visit_time desc" |
  awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\n", $1, $2}' |
  fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs open
}

fancy-branch() {
  local tags localbranches remotebranches target
  tags=$(
  git tag | awk '{print "\x1b[33;1mtag\x1b[m\t" $1}') || return
  localbranches=$(
  git for-each-ref --sort=-committerdate refs/heads/ |
  sed 's|.*refs/heads/||' |
  awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  remotebranches=$(
  git branch --remote | grep -v HEAD             |
  sed "s/.* //"       | sed "s#remotes/[^/]*/##" |
  sort -u             | awk '{print "\x1b[31;1mremote\x1b[m\t" $1}') || return
  target=$(
  (echo "$localbranches"; echo "$tags"; echo "$remotebranches";) |
  fzf --no-hscroll --ansi +m -d "\t" -n 2) || return
  if [[ -z "$BUFFER" ]]; then
    if [[ $(echo "$target" | awk '{print $1}') == 'remote' ]]; then
      target=$(echo "$target" | awk '{print $2}' | sed 's|.*/||')
      git checkout "$target"
      zle accept-line
    else
      git checkout $(echo "$target" | awk '{print $2}')
      zle accept-line
    fi
  else
    res=$(echo "$target" | awk '{print $2}')
    LBUFFER="$(echo "$LBUFFER" | xargs) ${res}"
    zle redisplay
  fi
}

fkill() {
  pid=$(ps -ef | sed 1d | fzf -m -e | awk '{print $2}')

  if [ "x$pid" != "x" ]
  then
    kill -${1:-9} $pid
  fi
}

fport() {
  pid=$(lsof -P | fzf -e | awk '{print $2}')
  if [ "x$pid" != "x" ]
  then
    kill -${1:-9} $pid
  fi
}



### WIDGETS
#  tmux set-buffer -b "a" "" && 
tmux-copy() {
  tmux copy-mode && tmux send-keys "?"
}

bindkey -s '^Q' 'tmux-copy\n'

# CTRL-U - Select user
__user() {
  local cmd="cat $HOME/users.csv"
  eval "$cmd" | $(__fzfcmd) --ansi -m | while read item; do
    printf '%q ' "$item"
  done
  echo
}

fzf-user-widget() {
  LBUFFER="${LBUFFER}$(__user)"
  zle redisplay
}
zle     -N   fzf-user-widget
bindkey '^U' fzf-user-widget

# CTRL-B - Select from clipboard history
__clipster() {
  local cmd="clipster -o -n 1000"
  eval "$cmd" | $(__fzfcmd) -m --ansi | while read item; do
    printf '%q ' "$item"
  done
  echo
}

fzf-clipster-widget() {
  LBUFFER="${LBUFFER}$(__clipster)"
  zle redisplay
}
zle     -N   fzf-clipster-widget
bindkey '^B' fzf-clipster-widget

# CTRL-E - Complete word on screen
__tmuxcomplete() {
  local cmd="tmuxcomplete"
  eval "$cmd" | $(__fzfcmd) | while read item; do
    printf '%q ' "$item"
  done
  echo
}

fzf-tmuxcomplete-widget() {
  LBUFFER="${LBUFFER}$(__tmuxcomplete)"
  zle redisplay
}
zle     -N   fzf-tmuxcomplete-widget
bindkey '^E' fzf-tmuxcomplete-widget

# CTRL-P - Copy word on screen to clipboard
__tmuxcopy() {
  local cmd="tmuxcomplete"
  eval "$cmd" | $(__fzfcmd) -m | while read item; do print "$item" | xclip -sel clip -i 
  done
  echo
}

fzf-tmuxcopy-widget() {
  LBUFFER="${LBUFFER}$(__tmuxcopy)"
  zle redisplay
}
zle     -N   fzf-tmuxcopy-widget
bindkey '^P' fzf-tmuxcopy-widget

__termjt() {
  tmux -c "/usr/bin/python3 /home/joetoth/bin/python/sel.py"
#  f="/tmp/termjt"
#  echo "" >! $f
#  tmux capture-pane -J -S 0 -p >| /tmp/tmux-pane-buffer
#  cat /tmp/tmux-pane-buffer | sed 's/[ \t]*$//' | tmux -c "termjt -regexp '(?m)\S{12,}|\d{4,10}' -outputFilename $f" 3>&1 1>&2 
#  ##termjt -outputFilename $f
#  value=$(cat $f) 
#  echo "$value"
}

termjt-screen-widget() {
  #LBUFFER="${LBUFFER}$(__termjt)"
  tmux -c "/usr/bin/python3 /home/joetoth/bin/python/sel.py"
  zle redisplay
}

zle     -N   termjt-screen-widget
bindkey '^S' 'termjt-screen-widget'
#bindkey -s '^S' 'tmux-copy\n'

#for script in $HOME/bin/python; do
#  x="python $script"
#  alias "${script:t:r}=$x"
#done


# Base16 Shell
#BASE16_SHELL="$HOME/base16-tomorrow.dark.sh"
#[[ -s $BASE16_SHELL ]] && . $BASE16_SHELL

# Kill app on port
# fuser -k 2222/tcp

# Battery
# upower -i $(upower -e | grep 'BAT') | grep -E "state|to\ full|percentage"
# Wireless commands
# iw dev
# ip link set wlan0 up  
# ip link wlan0 show
# iw wlan0 scan
# Add wireless network
# wpa_passphrase gorilla >> /etc/wpa_supplicant.conf 
# ...type in the passphrase and hit enter...
#
# wpa_supplicant -B -D wext -i wlan0 -c /etc/wpa_supplicant.conf
# dhclient wlan0
# edit /etc/network/interfaces and add wpa/psk
#
# Network Manager Command Line
# nmcli c up id joetoth.com
# nmcli dev wifi con "myssid" password "myssidpassword"
#
# You can also get a list of available access points with:
#
# nmcli dev wifi list


######### Initialize completion
source_if_exists $HOME/wdf/work.zsh

autoload -Uz compinit

export PATH="/Users/joetoth/homebrew/opt/llvm/bin:$PATH"
