# Aliases
alias vim=nvim
alias vi=nvim

alias mpcc="ncmpcpp -h ~/.mpd/socket"

alias m5s="md5sum $@"

alias ls="ls --color=always"

alias firefox-dev="firefox firefox-dev --private=firefox-dev"
alias firefox-mail="firefox firefox-email --private=firefox-email"
alias firefox-sas="firefox firefox-sas --private=firefox-sas"
alias firefox-priv="firefox firefox-priv"
alias firefox-htb="firefox firefox-htb --private=firefox-htb"

alias hless='f(){highlight -O truecolor $1 --force "${@:2}" | less}; f $@'
alias hcat='f(){highlight -O truecolor $1 --force "${@:2}"}; f $@'
