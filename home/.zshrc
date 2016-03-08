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

# stack completion
which stack && {
    autoload -U +X bashcompinit && bashcompinit
    eval "$(stack --bash-completion-script stack)"
}

# Source virtualenvs here
#~/.virtualenvs/projects.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Task autocompletion
fpath+=/usr/share/doc/task/scripts/zsh
compdef _task task
alias t=task
autoload _task

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

export TARDIR_EXCLUDE=".*~"
function _tardir () {
    dir=$1
    [ -z $1 ] && {
        echo "tardir directory [gz | bz2 | xz]"
        return 1
    }
    case $2 in
        "bz2")
            mode="cjvf"
            suffix="tar.bz2"
            ;;
        "xz")
            mode="cJvf"
            suffix="tar.xz"
            ;;
        *)
           mode="czvf"
           suffix="tar.gz"
    esac
    [ -d $dir ] || {
        red "$dir is not a valid directory"
        return 1
    }
    tarball=`basename $dir.$suffix`
    [ -f $tarball ] && {
        red "$tarball already exists in the file system"
        return 1
    }
    tmp_file=`tempfile`
    find $dir -regex $TARDIR_EXCLUDE > $tmp_file
    tar $mode $tarball $dir -X $tmp_file
    rm -rf $tmp_file
}
alias tardir="_tardir $@"
