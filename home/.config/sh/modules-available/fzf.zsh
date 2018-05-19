## fzf plugin
_gen_fzf_default_opts() {
  local bg="-1"
  local fg="#f5f5f5"
  local bg_plus="#75b5aa"
  local fg_plus="#332233"
  local marker="#90a959"
  local pointer="#90a959"
  local spinner="#90a959"
  local prompt="#f4bf75"
  local hl="#90a959"
  local hl_plus="#d60607"
  local info="#90a959"

  export FZF_DEFAULT_OPTS="
    --color fg:$fg,bg:$bg,hl:$hl,fg+:$fg_plus,bg+:$bg_plus,hl+:$hl_plus
    --color info:$info,prompt:$prompt,pointer:$pointer,marker:$marker,spinner:$spinner
    --border
    --inline-info
  "
}

FZF_DIR=~/.fzf
FZF_BIN=${FZF_DIR}/bin
FZF_SHELL=${FZF_DIR}/shell
FZF_DEFAULT_COMMAND="ag"

_gen_fzf_default_opts

[[ -x ${FZF_BIN}/fzf ]] && {
    path+=${FZF_BIN}
    source ${FZF_SHELL}/completion.zsh
    source ${FZF_SHELL}/key-bindings.zsh
}
