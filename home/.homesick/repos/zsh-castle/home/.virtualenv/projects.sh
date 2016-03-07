#!/bin/zsh

project=aitorbot
repos=pypi.cryptzone.ad
port=8080
# Aitorbot alias
AITORBOT_VIRTUALENV=/home/eof/.virtualenvs/aitorbot
function _aitorbot () {
    [ "$1" = "upgrade" ] && {
        source ${AITORBOT_VIRTUALENV}/bin/activate
        pip3 install --trusted-host pypi.cryptzone.ad --index http://pypi.cryptzone.ad:8080 --upgrade aitorbot
        deactivate
    } || {

        source ${AITORBOT_VIRTUALENV}/bin/activate
        aitorbot $@
        deactivate
    }
}
alias aitorbot=_aitorbot
