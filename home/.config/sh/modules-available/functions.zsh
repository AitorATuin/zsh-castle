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
    local profile
    local firejail_name
    local priv_folder
    local firejail_extra_opts
    local firefox_opts
    local firejail_dir=~/.firejail
    local firejail_profiles=${firejail_dir}/profiles
    local firejail_privates=${firejail_dir}/privates

    function usage() {
        echo "Usage: firefox firejail_ns [options]"
        echo ""
        echo "  --firejail-opts=\"extra options for firejail\""
        echo "  --firefox-opts=\"extra options for firefox\""
        echo "  --private=firejail_private_folder"
        echo "  --profile=firejail_profile"
        return 1
    }

    if [[ $# < 1 ]]; then
        usage
        return 1
    fi

    if [[ $1 =~ ^--help ]]; then
        usage
        return 1
    fi
    firejail_name=$1
    shift

    while [[ $# > 0 ]]; do
        if [[ $1 =~ ^--firejail-opts=(.+)$ ]]; then
            firejail_extra_opts="$match"
            shift
        elif [[ $1 =~ ^--firefox-opts=(.+)$ ]]; then
            firefox_opts=$match
            shift
        elif [[ $1 =~ ^--profile=(.+)$ ]]; then
            profile=$match
            shift
        elif [[ $1 =~ ^--private=(.+)$ ]]; then
            priv_folder=$match
            shift
        else
            usage
            return 1
        fi
    done

    local firejail_opts="--name=$firejail_name"

    if [[ $profile != "" ]]; then
        [[ ! -f $firejail_profiles/$profile ]] && {
            red "Profile $profile is not defined"
            return 1
        }
        firejail_opts="$firejail_opts --profile=${firejail_profiles}/${profile}"
    fi

    if [[ $priv_folder == "" ]]; then
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
    local firefox_bin=${FIREFOX_BIN:-/opt/firefox/firefox}
    echo "Running: firejail $firejail_opts ${firefox_bin} ${firefox_opts}"
    eval firejail $firejail_opts ${firefox_bin} ${firefox_opts}
}
