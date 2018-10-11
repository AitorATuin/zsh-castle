#!/bin/zsh

export NIX_REMOTE=daemon
source /etc/profile.d/nix.sh
source $HOME/.local/opt/nix-zsh-completions/nix.plugin.zsh
fpath=($HOME/.local/opt/nix-zsh-completions/xscs $fpath)
autoload -U compinit && compinit
