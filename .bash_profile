#; source .bashrc
if [ -f ~/.bashrc ]; then
  . ~/.bashrc
fi

#; record our system type for conditional configurations
system_type=$(uname -s)

set -o vi
umask 0022

#; prevent CTRL-d from closing the shell
set -o ignoreeof

#; correct minor spelling errors
shopt -s cdspell

#; multi-line commands in history
shopt -s cmdhist
shopt -s lithist

#; append history instead of overwriting
shopt -s histappend

#; tab completion
source ~/bin/complete/tmux
source ~/bin/complete/git

#; prompt
export REMOTE_STATUS=1
export BRANCH_STATUS=1
if [ "$system_type" = "Darwin" ]; then
  if [ -f "$HOME/bin/myprompt" ]; then
    PROMPT_COMMAND='PS1=$($HOME/bin/myprompt)'
  fi
else
  if [ -f "/usr/share/cs-prompt/csprompt" ]; then
    source /usr/share/cs-prompt/csprompt
  fi
fi

#; environment variables
export COLUMNS=`stty size | cut -d ' ' -f2`
export EDITOR=vim
export ENSCRIPT='-M Letter -j -E -T2 -U2 -r'
export HISTCONTROL=ignorespace:erasedups
export HISTSIZE=32768
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LESS="-XRMIQ"
export PATH=$PATH:$HOME/bin
export TERM=xterm-256color
export CSUSER=tbyrne
export YT=/Users/tbyrne/proj/yt/downloads

#; grep options
export GREP_COLOR='1;32'
export GREP_OPTIONS='--color=auto --exclude-dir=.svn --exclude-dir=.git'
if [ "$system_type" = "Darwin" ]; then
  alias grep="grep $GREP_OPTIONS"
  alias zgrep="zgrep $GREP_OPTIONS"
  alias fgrep="fgrep $GREP_OPTIONS"
fi

#; SVN env variables (REMOVE IN THE FUTURE)
if [ "$system_type" = "Linux" ]; then
  export SVNROOT=/data/svn/repos/il/ose
  export SVN=svn+ssh://csilsvn/$SVNROOT
fi

#; directory colors
if [ "$system_type" = "Darwin" ]; then
  eval $(gdircolors $HOME/.dir_colors)
else
  eval $(dircolors -b $HOME/.dir_colors)
fi

#; avoid problems with accidental CTRL-S flow control stops
stty ixany

#; aliases

alias ls='ls --color=tty -F'
alias clear='printf "\33[2J"'
alias cclear='/usr/bin/clear'
alias r='fc -e -'
alias ppp='pp-pretty'
alias ql='qlmanage -p'
alias irssi='TERM=xterm-256color irssi'
alias awget='wget --header "Pragma: akamai-x-cache-on, akamai-x-cache-remote-on, akamai-x-check-cacheable, akamai-x-get-cache-key, akamai-x-get-extracted-values, akamai-x-get-nonces, akamai-x-get-ssl-client-session-id, akamai-x-get-true-cache-key, akamai-x-serial-no"'

#; OSX overridden aliases
if [ "$system_type" = "Darwin" ]; then
  alias ls='gls --color=tty -F'
fi
