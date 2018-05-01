# Some env variables

# tmux likes screen-256color instead of xterm-256color, otherwise there are issues
# with ncurses windows
export TERM=screen-256color

export LESS='--quit-if-one-screen --ignore-case --status-column --LONG-PROMPT --RAW-CONTROL-CHARS --HILITE-UNREAD --tabs=4 --no-init --window=-4'
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

export EDITOR=nvim
export NVIM_TUI_ENABLE_TRUE_COLOR=1

export PYTHON=python3
export PIP=pip3

export MANPATH=$MANPATH:$HOME/man

export HISTFILE=~./histfile
export HISTSIZE=1000
export SAVEHIST=1000

eval $(dircolors)

export LOCALE=es_ES.utf8 

export FZF_ZSH=~/.zsh/fzf
export FZF_DEFAULT_OPTS='
  --bind ctrl-f:page-down,ctrl-b:page-up
  --inline-info
  --color fg:-1,bg:-1,hl:103,fg+:222,bg+:234,hl+:104
  --color info:183,prompt:110,spinner:107,pointer:167,marker:215
'
