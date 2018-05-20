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

function evim () {
    local NODE_MODE=production
    [ "$1" = "--dev" ] && {
        NODE_MODE=debug
        PARAMS=${@:2}
    } || PARAMS=$@
    NODE_ENV=$NODE_MODE ~/node_modules/nyaovim/bin/cli.js $PARAMS
}

function firefox() {
    local profile=$1
    local firejail_name=$2
    local priv_folder=$3
    local firejail_extra_opts=$4
    local firefox_opts=$5
    local firejail_dir=~/.firejail
    local firejail_profiles=${firejail_dir}/profiles
    local firejail_privates=${firejail_dir}/privates

    if [[ $# < 3 ]]; then
        echo "Usage: firefox profile jailname private_folder|none"
        return 1
    fi

    [[ ! -f $firejail_profiles/$profile ]] && {
        red "Profile $profile is not defined"
        return 1
    }

    local firejail_opts="--name=$firejail_name --profile=${firejail_profiles}/${profile}"

    if [[ $priv_folder == none ]]; then
        firejail_opts="$firejail_opts --private"
    else
        [[ ! -d $firejail_privates/$priv_folder ]] && {
            red "Private folder $priv_folder does not exists"
            return 2
        }
        firejail_opts="$firejail_opts --private=${firejail_privates}/${priv_folder}"
    fi

    if [[ ! -z $firejail_extra_opts ]]; then
        firejail_opts="$firejail_opts $firejail_extra_opts"
    fi

    if [[ -z $firefox_opts ]]; then
        firefox_opts="--no-remote"
    fi

    # TODO: get rif of eval :/
    eval firejail $firejail_opts /opt/firefox/firefox ${firefox_opts}
}
