# Author: Igor Zinovik <zinovik.igor@gmail.com>

# Initializing paths
cdpath=(..)
fpath=($fpath ~/.zshrc ~/.zsh/func)
path=(/bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin /usr/games ~/bin ~/golang/bin)
manpath=(/usr/share/man /usr/local/man /usr/X11R6/man)

# Remove duplicates from these arrays
typeset -U path cdpath fpath manpath

# Limits
ulimit
# Use limit built-in to discover limits
limit stack 8912       # Limit stack for each process
limit coredumpsize 3m  #
limit -s               # Apply previous settings for children processes
umask 022

# Initiating zsh options...
# autocd - change dirs in such way:
#          % /usr/src, without cd
# correct - enable spell checking for input commands
# caseglob - globbing is case-sensitive
# glob - enable filename generation aka globbing
# globcomplete -
# listtypes - when listing file, show the type of each file
# ignoreeof - use "exit" to close session, not via ^D
# markdirs - append '/' to all directory names
# histignoredups - duplicates in command history are not usefull
# histignorespace - dont put spaces to command history
# pushdignoredups - dont put dups to directory stack
setopt autocd
setopt correct
setopt caseglob
setopt glob
setopt globcomplete
setopt listtypes
setopt ignoreeof
setopt markdirs
setopt histignoredups
setopt histignorespace
setopt pushdignoredups
setopt prompt_subst
setopt no__nomatch
# I dont like beeping software
unsetopt beep


# Environment varaibles setting
export BLOCKSIZE=k           # 'du', 'df', 'ls -s' use this thing
export TZ=Europe/Moscow      # Timezone
export HISTFILE=/dev/null    # History storage
HISTSIZE=1024                # Maximum size of internal history list
SAVEHIST=1024                # Maximum amount of command history file can store
NULLCMD=cat                  # redirection '# <file' now works in such way:
READNULLCMD=less             # 'cat file|less'
WATCHFMT='%B%n has %a at %T %l from %M'  # Show place from was made last login
TIMEFMT='%E total %J'        # output format for 'time' built-in
export LANG="en_US.utf8"
export LC_CTYPE="en_US.utf8"
export LC_NUMERIC=en_US.utf8
export LC_TIME=en_US.utf8
export LC_COLLATE="en_US.utf8"
export LC_MONETARY=en_US.utf8
export LC_MESSAGES="en_US.utf8"
export LC_PAPER=en_US.utf8
export LC_NAME=en_US.utf8
export LC_ADDRESS=en_US.utf8
export LC_TELEPHONE=en_US.utf8
export LC_MEASUREMENT=en_US.utf8
export LC_IDENTIFICATION=en_US.utf8
export EDITOR=vim
export VISUAL=vim
export PAGER=less     # PAGER for man(1) command
export LESS='-FirSwX' # Pager options

# Terminal colours
# %f - reset color settings
R='%F{red}'
M='%F{magenta}'
B='%F{blue}'
G='%F{green}'
Y='%F{yellow}'
C='%F{cyan}'
W='%F{white}'

# Enable VCS plugin
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git hg
zstyle ':vcs_info:*' stagedstr "($G±%f)"
zstyle ':vcs_info:*' unstagedstr "[${R}!%f]"
zstyle ':vcs_info:*' formats "%f@%b%u%c"
zstyle ':vcs_info:*' actionformats "%F{5}@[%F{2}%b%F{3}|%F{1}%a%F{5}]%f"
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:hg:*' hgrevformat ""

setopt prompt_subst

case $TERM in
  (E|a|x)term* | screen* )
    # Execute before each prompt
    precmd() {
      print -Pn "\033]0;%n@%M(%y)\a"      # Configuring the xterm window caption
      print -Pn "\033]1;%n@%m(tty%l)\a"
      vcs_info
      PROMPT="$Y($G%~$Y)%(1j.$Y{$C%j$Y}.)[$G%!$Y]${vcs_info_msg_0_}$Y%(!.$R%#.$W%%)%f "

      #RPROMPT='[$(git_prompt)]'
    }
    # Execute just after command has been read
    preexec() {
      print -Pn "\033]0;%n@%M(%y)\a"
      print -Pn "\033]1;%n@%m(tty%l)\a"
    }
    ;;
esac


# Right-side prompt
#RPROMPT='[%T]'
# Spell checker prompt
SPROMPT='zsh: correct '%R' to '%r' ([Y]es/[N]o/[E]dit/[A]bort)? '

# Aliases
# N.B. no spaces around '='

# System administration and performance analysis
alias d=docker
alias di='diff -aup'
alias dfh='df -h'
alias duh='du -h'
# Show top 5 disk space consumers
alias du5="du -h . | sort -hr| head -n 6 | sed '1 d'"
alias cpu5='ps -ax --sort=-%cpu,-%mem -o pid,%cpu,%mem,comm |head -n 6'
alias psaux='ps aux'
alias l='less -R'
alias s=ssh
alias p=ping
alias p6=ping6

# SCM
alias g=git

# Dev tools
alias gdb='gdb -q'
alias mk=make

# Ruby
alias be='bundle exec'
alias rk=rake

# Shell nifty helpers
alias ez='$EDITOR ~/.zshrc'
alias ezl='$EDITOR ~/.zshrc.local'
alias exit='cat /dev/null > ~/.zsh_history;sync;sync;clear;exit'
alias j='jobs -l'       # jobs with PIDs
alias pu=pushd
alias po=popd
alias h='history -20'
alias v=vim

# Global aliases
alias -g L='| less'


# Key-bindings
# bindkey will show all binds
bindkey -e                           # Enable Emacs key-bindings
bindkey "\e[1~" beginning-of-line    # Home
bindkey "\e[2~" transpose-words      # Insert
bindkey "\e[3~" delete-char          # Delete
bindkey "\e[4~" end-of-line          # End
bindkey "\e[5~" up-line-or-hisory    # PgUp
bindkey "\e[6~" down-line-or-hisory  # PgDown


# Initialize zsh autocompletion module
autoload -U compinit
compinit

# Enabling color (GNU ls) highlightment for completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}



# Hash directories
hash -d dl=~/Downloads
hash -d t=~/tmp
hash -d log=/var/log

#if `which dircolors` > /dev/null; then
#  eval `dircolors`
#elif [ -x `which gdircolors` ]; then
#  eval `gdircolors`
#else
#  LS_COLORS="no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:"
#  LS_COLORS="${LS_COLORS}or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:"
#  LS_COLORS="${LS_COLORS}*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:"
#fi

# OS specific settings
case `uname -s` in
  Linux)
    alias sc=systemctl
    alias pstree='pstree -Gch'
    alias ll='ls -FLXh -li --color=auto'
    alias la='ls -FLAXh --color=auto'
    alias ls='ls -FLX --color=auto'
    alias yum='yum -q'

    eval `dircolors -b`
    ;;
esac

function cpo()
{
  if [ $# -le 0 ]; then
    echo "usage: cpo file..."
  else
    for i in "$@"; do
      cp $i{,.orig}
    done
  fi
}

function tgz()
{
  if [ $# -le 0 ]; then
    echo "usage: tgz dir"
    return 1
  fi

  if [ -d "$1" ]; then
    tar cf $1.tar $1
    gzip $1.tar
  else
    echo "directory $1 does exist"
  fi
}



# Variable for ~/.config/systemd/user/ssh-agent.service
#export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.sock"

# Settings specific to current host
ZSHRC_LOCAL=~/.zshrc.local
if [ -r $ZSHRC_LOCAL ]; then
  source $ZSHRC_LOCAL
fi
