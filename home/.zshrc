# Uncomment to profile zsh startup
##zmodload zsh/zprof

# Do some manual time profiling
integer t0=$(date '+%s')

# Init vars
SH_CONFIG_DIR=~/.config/sh
SH_CONFIG_ENABLED=$SH_CONFIG_DIR/modules-enabled
DEBUG=0

# autoload compinit here
autoload -Uz compinit; compinit

# Load enabled modules
for mod in $SH_CONFIG_ENABLED/*; do
    [[ $DEBUG == 1 ]] && echo "Loading $mod ..."
    source $mod
done

function {
    local -i t1 startup
    t1=$(date '+%s')
    startup=$(( t1 - t0 ))
    [[ $startup -gt 1 ]] && print "Hmm, poor shell startup time: $startup"
    # print "startup time: $startup"
}
unset t0

# Call compinit again, for reason some modules are not resync
compinit

# Uncomment to let zsh to do some profiling
##zprof
