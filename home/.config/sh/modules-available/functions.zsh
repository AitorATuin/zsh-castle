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

function debug_comp () {
    zstyle ':completion:*' verbose yes
    zstyle ':completion:*:descriptions' format  '%B%d%b'
    zstyle ':completion:*:messages' format '%d'
    zstyle ':completion:*:warnings' format 'No matches for :%d'
    zstyle ':completion:*' group-name
}

function detect_powerline() {
    local pyver=$(python3 --version | awk '{v=$2;sub(/\.[^\.]$/, "", v);print(v)}')
    local pypath="python$pyver"
    if [ -d $HOME/.virtualenvs/powerline/bin ]
    then
        #export POWERLINE_CONFIG_COMMAND=$HOME/.virtualenvs/powerline/bin/powerline-config
    fi
    if [ $ARCH = "x86_64" ] && [ -d $HOME/.virtualenvs/powerline/lib64/$pypath/site-packages/powerline/ ]
    then
        export POWERLINE_HOME=$HOME/.virtualenvs/powerline/lib64/$pypath/site-packages/powerline/
    elif [ -d $HOME/.virtualenvs/powerline/lib/$pypath/site-packages/powerline/ ]
    then
        export POWERLINE_HOME=$HOME/.virtualenvs/lib/$pypath/site-packages/powerline/
    fi
}

function evim () {
    local NODE_MODE=production
    [ "$1" = "--dev" ] && {
        NODE_MODE=debug
        PARAMS=${@:2}
    } || PARAMS=$@
    NODE_ENV=$NODE_MODE ~/node_modules/nyaovim/bin/cli.js $PARAMS
}
