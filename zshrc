# $Id: zshrc,v 1.82 2011/04/26 12:33:50 zinovik Exp $
#
# Author: Igor Zinovik <zinovik.igor@gmail.com>

# Initializing paths
cdpath=(..)
fpath=($fpath ~/.zshrc ~/.zsh/func)
path=(/bin /sbin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin /usr/games ~/bin)
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
setopt autocd correct caseglob glob globcomplete listtypes
setopt ignoreeof markdirs histignoredups histignorespace pushdignoredups
setopt prompt_subst
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
export LC_CTYPE="en_US.UTF-8"
export LC_NUMERIC=en_US.UTF-8
export LC_TIME=en_US.UTF-8
export LC_COLLATE="en_US.UTF-8"
export LC_MONETARY=en_US.UTF-8
export LC_MESSAGES="en_US.UTF-8"
export LC_PAPER=en_US.UTF-8
export LC_NAME=en_US.UTF-8
export LC_ADDRESS=en_US.UTF-8
export LC_TELEPHONE=en_US.UTF-8
export LC_MEASUREMENT=en_US.UTF-8
export LC_IDENTIFICATION=en_US.UTF-8
export EDITOR=vim
export VISUAL=vim
export PAGER=less            # PAGER for man(1) command
#export LESS='-M -I -J -S -s' # Pager options

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

setopt prompt_subst

# Configuring the xterm window caption
case $TERM in
  (E|a|x)term* | screen* )
    # Execute before each prompt
    precmd() {
      print -Pn "\033]0;%n@%M(%y)\a"
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
alias d='diff -aup'
alias df='df -h'
alias du='du -h'
alias duh="du -h . | grep -v '/.*/' | sort -n"
alias exit='cat /dev/null > ~/.zsh_history;sync;sync;clear;exit'
alias ez='$EDITOR ~/.zshrc'
alias g=git
alias gdb='gdb -q'
alias mk=make
alias j='jobs -l'       # jobs with PIDs
alias psaux='ps aux'
alias pu=pushd
alias po=popd
alias l='less -R'
alias h='history -20'
alias s=ssh
alias v=vim
# Global aliases
alias -g H='--help | less'


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
hash -d include='/usr/include'
hash -d log='/var/log'

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
  OpenBSD)
    export CVSROOT=/cvs

    if [ -x /usr/local/bin/gls ]; then
      eval `gdircolors -b`
      alias ll='gls -FLXh -li --color=auto'
      alias la='gls -FLAXh --color=auto'
      alias ls='gls -FLX --color=auto'
    fi

    alias cal='cal -m'
    alias -g PL=/usr/ports/infrastructure/bin/portslogger

    # I never can remember what is written in release(8)
    alias rmobjs='(cd /usr/obj && mkdir -p .old && sudo mv * .old && sudo rm -rf .old)'
    alias objrebuild='(cd /usr/src && nice make obj)'
    alias makedistrib='(cd /usr/src/etc && env DESTDIR=/ sudo make distrib-dirs)'
    alias mkkernel='make clean && make depend && make'
    alias mkbuild='cd /usr/src && nice sudo make build'

    hash -d rc.d=/etc/rc.d
    hash -d src=/usr/src
    hash -d sys=~src/sys
    hash -d regress=~src/regress
    hash -d ubin=~src/usr.bin
    hash -d usbin=~src/usr.sbin

    # usefull for porters
    hash -d pobj=/usr/obj/ports
    hash -d ports=/usr/ports
    hash -d distfiles=~ports/distfiles
    hash -d mystuff=~ports/mystuff
    hash -d rc.d=/etc/rc.d
    hash -d www=/var/www

    # Usefull autocomplete targets for make (helpful for port maintainers)
    targets=(build build-depends checksum clean configure deinstall \
      depend distclean dump-vars extract fake fetch install lib-depends \
      license-check makesum package patch print-build-depends \
      print-run-depends print-package-signature print-plist \
      port-lib-depends-check rebuild regress reinstall repackage \
      update update-patches update-plist)
    compctl -k targets make

    # Usefull function to find 'use clauses in perl modules and
    # scripts.  Maybe not perfect but enough for me right now.
    p5deps()
    {
      if [ $# -ne 1 ]; then
        echo "usage: $0 path"
      else
        find "$1" -name \*.pm -print0 -or -name \*.pl -print0 -or \
          -type f -perm -0100 -print0 | \
          xargs -0 egrep '^use (.)*::(.)*;' | perl -pi -e \
          's,^(.)*:use ,,g' | egrep -v "[\)0-9\'];$" | \
          sort | uniq
      fi
    }

    mdocpkglint()
    {
      if [ $# -ne 1 ]; then
        echo "usage: $0 pkgname"
      else
        pkg_info -L $1 | egrep -e '\.[0-9]p?$' | xargs mandoc -Tlint -Werror
      fi
    }
    ;;

  FreeBSD)
    LANG=en_US.UTF-8

    if [ -x /usr/local/bin/gnuls ]; then
      eval `dircolors -b`
      alias ll='gnuls -FLXh -li --color=auto'
      alias la='gnuls -FLAXh --color=auto'
      alias ls='gnuls -FLX --color=auto'
    fi

    hash -d etc=/usr/local/etc
    hash -d ports=/usr/ports
    hash -d rc.d=/usr/local/etc/rc.d
    hash -d local=/usr/local
    ;;
  Linux)
    alias pstree='pstree -Gch'
    alias ll='ls -FLXh -li --color=auto'
    alias la='ls -FLAXh --color=auto'
    alias ls='ls -FLX --color=auto'
    alias yum='yum -q'

    export TERM=xterm-256color

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


# color - display ANSI colours.
function color
{
  esc="\033["
  echo -e "\t  40\t   41\t   42\t    43\t      44       45\t46\t 47"
  for fore in 30 31 32 33 34 35 36 37; do
    line1="$fore  "
    line2="    "
    for back in 40 41 42 43 44 45 46 47; do
      line1="${line1}${esc}${back};${fore}m Normal  ${esc}0m"
      line2="${line2}${esc}${back};${fore};1m Bold    ${esc}0m"
    done
    echo -e "$line1\n$line2"
  done
  echo ""
  echo "# Example:"
  echo "#"
  echo "# Type a Blinkin COLOR in colours (Yellow on Blue)"
  echo "#"
  echo "#           ESC"
  echo "#            |  CD"
  echo "#            |  | CD2"
  echo "#            |  | | FG"
  echo "#            |  | | |  BG + m"
  echo "#            |  | | |  |         END-CD"
  echo "#            |  | | |  |            |"
  echo "# echo -e '\033[1;5;33;44mCOLOR\033[0m'"
}

# Variable for ~/.config/systemd/user/ssh-agent.service
#export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.sock"

# Settings specific to current host
ZSHRC_LOCAL=~/.zshrc.local
if [ -r $ZSHRC_LOCAL ]; then
  source $ZSHRC_LOCAL
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
