export TERM=xterm-256color
# Locale
export LANG=es_ES.utf8
export LC_ALL=es_ES.utf8

export PATH=$HOME/bin:$HOME/.luarocks/bin:$HOME/.local/bin:$PATH
export MANPATH=$MANPATH:$HOME/man

export LESS="-F -X -R"
export EDITOR=vim

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob nomatch notify prompt_subst
unsetopt beep
bindkey -v
bindkey -M vicmd '?' history-incremental-search-backward

# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/atuin/.zshrc'
# End of lines configured by zsh-newuser-install

function detect-os() {
	if [[ `uname` == 'Linux' ]]
	then
		export LINUX=1
		export GNU_USERLAND=1
	else
		export LINUX=
	fi

	if [[ `uname` == 'Darwin' ]]
	then
		export OSX=1
	else
		export OSX=
	fi

	# Detect Macports GNU userland installation
	if [[ "$OSX" == "1" ]]
	then
	    if [[ -e /opt/local/libexec/gnubin ]]
	    then
		export GNU_USERLAND=1
	    fi
	fi
}
detect-os

source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)
fpath=($HOME/.zsh/autoload $fpath)

# Shell bookmarks
autoload cdg
autoload lsp
autoload tardir

# Setup GHC path on macosx
PATH="$HOME/.cabal/bin:$PATH"
[ $OSX ] && {
	# Add GHC 7.8.3 to the PATH, via http://ghcformacosx.github.io/
	export GHC_DOT_APP="/opt/homebrew-cask/Caskroom/ghc/7.8.3-r1/ghc-7.8.3.app"
	if [ -d "$GHC_DOT_APP" ]; then
	    export PATH="${GHC_DOT_APP}/Contents/bin:${PATH}"
	fi
}

# Locale
[ $OSX ] && {
    export LC_ALL=es_ES.UTF-8  
    export LANG=es_ES.UTF-8
} || {
    export LC_ALL=es_ES.utf8
    export LANG=es_ES.utf8
}

autoload -Uz compinit
# The following lines were added by compinstall
zstyle :compinstall filename '/Users/atuin/.zshrc'

# End of lines added by compinstall

# ranger stuff
export W3MIMGDISPLAY_PATH=/usr/libexec/w3m/w3mimgdisplay
export RANGER_LOAD_DEFAULT_RC=FALSE

# Nyaovim start
function evim () {
    local NODE_MODE=production
    [ "$1" = "--dev" ] && {
    	NODE_MODE=debug
        PARAMS=${@:2}
    } || PARAMS=$@
    NODE_ENV=$NODE_MODE ~/node_modules/nyaovim/bin/cli.js $PARAMS
}

# colors in ls
eval $(dircolors)
alias ls="ls --color=always"
compinit

# Source antigen-hs
#  Fix the script to install antigen on first boot
ANTIGEN_HS_RC=~/.zsh/antigen-hs/init.zsh
[ -f $ANTIGEN_HS_RC ] && {
	echo -e "\033[0;36m * antigen-hs installed. Loading antigen-hs"
	source $ANTIGEN_HS_RC
} || {
	echo -e "\033[0;33m * antigen-hs not installed, cloning now"
	git clone https://github.com/Tarrasch/antigen-hs.git ~/.zsh/antigen-hs
	source $ANTIGEN_HS_RC
	antigen-hs-compile
	source $ANTIGEN_HS_RC
}

# Theme
THEMES_DIR=~/.zsh/themes
CURRENT_THEME=${THEMES_DIR}/current
source ~/.zsh/themes/current/theme.zsh-theme

# completion on first-tab
zstyle ':completion:*' menu select
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)*==34=34}:${(s.:.)LS_COLORS}")'
function first-tab () {
	[ $#BUFFER = 0 ] && {
		BUFFER="cd "
		CURSOR=3
		zle list-choices
	} || {
		zle expand-or-complete
	}
}
zle -N first-tab
bindkey '^I' first-tab

# stack completion
which stack > /dev/null && {
    autoload -U +X bashcompinit && bashcompinit
    eval "$(stack --bash-completion-script stack)"
}

# Source virtualenvs here
#~/.virtualenvs/projects.sh

# FZF config
export FZF_ZSH=~/.zsh/fzf
export FZF_DEFAULT_OPTS='
  --bind ctrl-f:page-down,ctrl-b:page-up
  --inline-info
  --color fg:-1,bg:-1,hl:103,fg+:222,bg+:234,hl+:104
  --color info:183,prompt:110,spinner:107,pointer:167,marker:215
'
[ -f ${FZF_ZSH}/fzf.zsh ] && source ${FZF_ZSH}/fzf.zsh

# Task autocompletion
fpath+=/usr/share/doc/task/scripts/zsh
compdef _task task
alias t=task
autoload _task

# key chain
eval `keychain --eval`
fpath+=$HOME/.zsh/completions
function addkey () {
    local key=$1
    [ -f $HOME/.ssh/$key.rsa ] && {
        keychain $HOME/.ssh/$key.rsa
        return 0
    }
    [ -f $HOME/.ssh/$key ] && {
        keychain $HOME/.ssh/$key
        return 0
    }
    red "Unable to find key $key"
}
compinit
compdef addkey='_addkey'
keys=`ssh-add -l`
[ $? -eq 0 ] && {
    cyan " * Loading keys ..."
    for key in $(echo $keys | awk '{print($3)}'); do
        keychain -q $key
    done
}

# some alias
alias m5s="md5sum $@"
local _dfc_bin=`which dfc`
function _dfc () {
    [ "$1" = "-r" ] && {
        shift
        df $@
    } || dfc $@
}
[ -x $_dfc_bin ] && alias df=_dfc

alias vim="gvim -v"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
