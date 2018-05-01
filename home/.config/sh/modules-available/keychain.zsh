# Keychain

which keychain >/dev/null && {
    eval `keychain --eval`
    autoload addkey
    compdef _addkey addkey
    local keys
    keys=`ssh-add -l`
    [ $? -eq 0 ] && {
        cyan " * Loading keys ..."
        for key in $(echo $keys | awk '{print($3)}'); do
            keychain -q $key
        done
    }
}
