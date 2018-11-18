#!/bin/zsh

export NIX_REMOTE=daemon
export LOCALE_ARCHIVE=$HOME/.nix-profile/lib/locale/locale-archive
source /etc/profile.d/nix.sh
source $HOME/.local/opt/zsh-nix-shell/nix-shell.plugin.zsh
source $HOME/.local/opt/nix-zsh-completions/nix.plugin.zsh
fpath=($HOME/.local/opt/nix-zsh-completions $fpath)
autoload -U compinit && compinit
prompt_nix_shell_setup "$@"
