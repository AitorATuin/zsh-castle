## fzf plugin

FZF_DIR=~/.fzf
FZF_BIN=${FZF_DIR}/bin
FZF_SHELL=${FZF_DIR}/shell

[[ -x ${FZF_BIN}/fzf ]] && {
    path+=${FZF_BIN}
    source ${FZF_SHELL}/completion.zsh
    source ${FZF_SHELL}/key-bindings.zsh
}
