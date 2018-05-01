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

