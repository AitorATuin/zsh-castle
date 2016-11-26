
# Some env variables
#
export TERM=xterm-256color
export PATH=$HOME/bin:$HOME/.luarocks/bin:$HOME/.local/bin:$PATH
export MANPATH=$MANPATH:$HOME/man
export LESS="-F -X -R"
export EDITOR=nvim
export PYTHON=python3
export PIP=pip3

# Some basic aliases
alias vim=nvim
alias vi=nvim

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

function detect-distro() {
    if [ -f /etc/slackware-version ];
    then
        export LINUX_DISTRO=slackware
    elif [ -d /System ];
    then
        export LINUX_DISTRO=GoboLinux
    else
        export LINUX_DISTRO=unknown
    fi
}

function detect-os() {
    if [[ `uname` == 'Linux' ]]
    then
        export LINUX=1
        export GNU_USERLAND=1
        if [[ `arch` == 'x86_64' ]]
        then
            export ARCH=x86_64
        else
            export ARCH=i686
        fi
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
[ ${LINUX-0} -eq 1 ] && detect-distro

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
export LOCALE=es_ES.utf8 
[ $OSX ] && {
    export LC_ALL=${LOCALE}  
    export LANG=${LOCALE}
} || {
    locale -a 2>/dev/null | grep ${LOCALE} >/dev/null || {
        export LOCALE=en_US.utf8
    }
    export LANG=${LOCALE}
    export LC_ALL=${LOCALE}

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

# Homeshick
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

# Desk
fpath=($HOME/.local/share/zsh/desk $fpath)

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
[ -f ${CURRENT_THEME}/theme.zsh-theme ] && source ~/.zsh/themes/current/theme.zsh-theme

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

# GO Stuff
# By default unset always GOBIN so new packages will go to GOPATH
unset GOBIN
export GOPATH=$HOME/Projects/go
export NVIM_GOPATH=$HOME/.local/share/vim/go
function go_path () {
    [ -d $1 ] && {
        export GOPATH=$1
        export PATH=$PATH:$GOPATH/bin
    } || red "$1 is not a directory"
}
[ -z ${GOPATH} ] && {
    yellow " * GOPATH is not set!, setting it $HOME/.go"
    go_path $HOME/.go
} ||  go_path ${GOPATH}

# nvim go path
[ -d $NVIM_GOPATH ] && export PATH=$PATH:$NVIM_GOPATH/bin

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

# Custom autoload commands
fpath+=$HOME/.zsh/completions
fpath=($HOME/.zsh/autoload $fpath)
autoload cdg
autoload lsp
autoload tardir
autoload addkey

# key chain
which keychain >/dev/null && {
    eval `keychain --eval`
    compinit
    compdef addkey='_addkey'
    keys=`ssh-add -l`
    [ $? -eq 0 ] && {
        cyan " * Loading keys ..."
        for key in $(echo $keys | awk '{print($3)}'); do
            keychain -q $key
        done
    }
}

# some alias
alias m5s="md5sum $@"
local _dfc_bin=`which dfc 2>/dev/null`
[ ! -z ${_dfc_bin} ] && [ -x $_dfc_bin ] && {
    function _dfc () {
        [ "$1" = "-r" ] && {
            shift
            df $@
        } || dfc $@
    }
    alias df=_dfc
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# azure completion
[ -f ~/.zsh/completions/azure ] && source ~/.zsh/completions/azure

# set stack aliases
[ -x $HOME/.cabal/bin/stack ] && {
    alias ghci='stack exec -- ghci'
    alias ghc='stack exec -- ghc'
}

# Powerline home
[ $ARCH = "x86_64" ] && {
    export POWERLINE_HOME=$HOME/.local/lib64/python3.5/site-packages/powerline/
} || {
    export POWERLINE_HOME=$HOME/.local/lib/python3.5/site-packages/powerline/
}

function detect_powerline() {
    if [ $ARCH = "x86_64" ] && [ -d $HOME/.local/lib64/python3.5/site-packages/powerline/ ]
    then
        export POWERLINE_HOME=$HOME/.local/lib64/python3.5/site-packages/powerline/
    elif [ -d $HOME/.local/lib/python3.5/site-packages/powerline/ ]
    then
        export POWERLINE_HOME=$HOME/.local/lib/python3.5/site-packages/powerline/
    fi
}
[ -z ${POWERLINE_HOME+1} ] && detect_powerline

# tmux python powerline
tmux_bin=$(which tmux)
function run_tmux () {
    local args=$1
    [ -z $args ] && $tmux_bin || $tmux_bin "$args"
}
function tmux_f() {
    [ "$TMUX_NO_POWERLINE" = "1" ] && {
        local force=1
    } || {
        local force=0
    }
    local args=$@
    if [ -d $POWERLINE_HOME ]
    then
        run_tmux $@
    elif [ $force -eq 1 ]
    then
        run_tmux $@
    else
        yellow "Powerline not installed!"
        yellow "Install it using `pip3 install --user` or set the env var TMUX_NO_POWERLINE=1 to run it without powerline"
    fi
}
# This is needed, otherwise default fzf-tmux will be called always
[ -z $TMUX ] && export FZF_TMUX=-1 || export FZF_TMUX=1
alias tmux=tmux_f

# Tmuxinator
TMUXINATOR_HOME=$HOME/.gem/ruby/2.2.0
[ -d $TMUXINATOR_HOME ] && {
    compdef _tmuxinator tmuxinator mux
    export PATH=$PATH:$TMUXINATOR_HOME/bin
    alias mux="tmuxinator"
}
# ncmpcpp alias
alias mpcc=ncmpcpp

[ ${LINUX-0} -eq 1 ] && [ ${LINUX_DISTRO} = "slackware" ] && {
    alias go-gcc=/usr/bin/go
    alias go=/usr/lib64/go1.7.3/go/bin/go
}

function debug_comp () {
    zstyle ':completion:*' verbose yes
    zstyle ':completion:*:descriptions' format  '%B%d%b'
    zstyle ':completion:*:messages' format '%d'
    zstyle ':completion:*:warnings' format 'No matches for :%d'
    zstyle ':completion:*' group-name
}

# Hook for desk activation
[ -n "$DESK_ENV" ] && source "$DESK_ENV" || true
