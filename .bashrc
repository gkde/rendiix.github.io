case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth

shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /data/data/com.termux/files/usr/bin/lesspipe ] && eval "$(SHELL=/data/data/com.termux/files/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /data/data/com.termux/files/usr/etc/debian_chroot ]; then
    debian_chroot=$(cat /data/data/com.termux/files/usr/etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /data/data/com.termux/files/usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=yes
    fi
fi

NO=$'\033[00m';ME=$'\033[31m';HI=$'\033[32m';KU=$'\033[33m'BI=$'\033[34m';CY=$'\033[36m';PU=$'\033[37m'
MET=$'\033[01;31m';HIT=$'\033[01;32m';KUT=$'\033[01;33m';BIT=$'\033[01;34m';CYT=$'\033[01;36m';PUT=$'\033[01;37m';MGT=$'\033[01;35m'

R=$(( $RANDOM % 10 + 30 ))

PROMPT_PROGRAM() {
	if [ "$?" = 0 ]; then
		errnot='✔'
		errcolor=$KUT
	else
     errnot='✘'
		errcolor=$MET
	fi
    if [ "$EUID" != 0 ]; then
        user_color=$HIT
        folder_color=$CYT
        user='ganti_pake_nama_kamu@termux'
    else
        user_color=$MET
        folder_color=$MET
        user='root@termux'
    fi
    if [ -z "$(git branch 2>/dev/null | grep '^*' | colrm 1 2)" ]; then
    gitbranch='●'
    gitbranch_color=$KUT
    else
    gitbranch="branch:$(git branch 2>/dev/null | grep '^*' | colrm 1 2)"
    gitbranch_color=$MGT
    fi
}
kanan() {
tanggal=$(echo -e "$PUT[${BIT}$(date "+%R %Z")$PUT]")
printf "%*s" "$(($(tput cols)+24))" "$tanggal"
}

PROMPT_COMMAND=PROMPT_PROGRAM
PS1='\[$(tput sc; kanan; tput rc;)\]\[$PUT\]┌─[\[$user_color\]$user\[$PUT\]]─[\[$gitbranch_color\]$gitbranch\[$PUT\]]─[\[$errcolor\]$errnot\[$PUT\]]
\[$PUT\]├─[\[$folder_color\]\w\[$PUT\]]
\[$PUT\]│
\[$PUT\]└─[\[$user_color\]\$\[$PUT\]]─●\[$NO\]\[$PU\] '
trap 'echo -ne "\e[0m" ' DEBUG

unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /data/data/com.termux/files/usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias q='exit'
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias sudo='tsu -c '
alias su='tsu -c '
export GPG_TTY=$(tty)

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

