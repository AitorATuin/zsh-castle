# Aliases
alias vim=nvim
alias vi=nvim

alias mpcc=ncmpcpp -h ~/.mpd/socket

alias m5s="md5sum $@"

alias ls="ls --color=always"

alias firefox-dev="firefox firefox.profile firefox-dev firefox-dev"
alias firefox-mail="firefox firefox.profile firefox-email firefox-mail"
alias firefox-priv="firefox firefox.profile none firefox-priv"

alias hless='f(){highlight -O truecolor $1 --force "${@:2}" | less}; f $@'
alias hcat='f(){highlight -O truecolor $1 --force "${@:2}"}; f $@'
