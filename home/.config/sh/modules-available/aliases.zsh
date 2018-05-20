# Aliases
alias vim=nvim
alias vi=nvim

alias mpcc=ncmpcpp -h ~/.mpd/socket

alias m5s="md5sum $@"

alias ls="ls --color=always"

# firejail
FIREJAIL_DIR=~/.firejail
FIREFAIL_PROFILES=~/.firejail/profiles
alias firefox-dev="firejail --name=firefox-dev --profile=${FIREFAIL_PROFILES}/firefox.profile --private=${FIREJAIL_DIR}/firefox-dev /opt/firefox/firefox --no-remote $@"
