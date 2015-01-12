# Locale
export LANG=es_ES.utf8
export LC_ALL=es_ES.utf8
>>>>>>> 01065e9... Added locale

export PATH=$PATH:$HOME/bin
export MANPATH=$MANPATH:$HOME/man

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

ANTIGEN_HS_RC=~/.zsh/antigen-hs/init.zsh
echo $ANTIGEN_HS_RC
[ -f $ANTIGEN_HS_RC ] && {
	echo "Loading antigen-hs"
	source $ANTIGEN_HS_RC
} || {
	echo "antigen-hs not installed, cloning now"
	git clone https://github.com/Tarrasch/antigen-hs.git ~/.zsh/antigen-hs
	echo "Compiling file"
	source $ANTIGEN_HS_RC
	antigen-hs-compile
	source $ANTIGEN_HS_RC
}

# The following lines were added by compinstall
zstyle :compinstall filename '/Users/atuin/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

#source /Users/atuin/Developer/Logikujo/pure/pure.plugin.zsh
#fpath+=/Users/atuin/Developer/Logikujo/pure


