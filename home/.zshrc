# Locale
export LANG=es_ES.utf8
export LC_ALL=es_ES.utf8
>>>>>>> 01065e9... Added locale

export PATH=$PATH:$HOME/bin:$HOME/.luarocks/bin
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

# Setup GHC path on macosx
[ $OSX ] && {
	# Add GHC 7.8.3 to the PATH, via http://ghcformacosx.github.io/
	export GHC_DOT_APP="/opt/homebrew-cask/Caskroom/ghc/7.8.3-r1/ghc-7.8.3.app"
	if [ -d "$GHC_DOT_APP" ]; then
	    export PATH="${HOME}/.cabal/bin:${GHC_DOT_APP}/Contents/bin:${PATH}"
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


# The following lines were added by compinstall
zstyle :compinstall filename '/Users/atuin/.zshrc'

autoload -Uz compinit
compinit
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

# Source antigen-hs
#  Fix the script to install antigen on first boot
ANTIGEN_HS_RC=~/.zsh/antigen-hs/init.zsh
[ -f $ANTIGEN_HS_RC ] && {
	echo "antigen-hs installed. Loading antigen-hs"
	source $ANTIGEN_HS_RC
} || {
	echo "antigen-hs not installed, cloning now"
	git clone https://github.com/Tarrasch/antigen-hs.git ~/.zsh/antigen-hs
	echo "Compiling file"
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
