# Set options

setopt appendhistory \
    autocd \
    extendedglob \
    nomatch \
    noify \
    prompt_subst

unsetopt beep

# autoload some stuff
zstyle :compinstall filename '/Users/atuin/.zshrc'
autoload -Uz compinit; compinit
zstyle ':completion:*' menu select
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)*==34=34}:${(s.:.)LS_COLORS}")'
autoload -Uz promptinit; promptinit
autoload cdg \
    lss \
    lsp \
    tardir \
    addkey \
    bandcamp-dl

# Keybinding

bindkey -v
bindkey -M vimcd '?' history-incremental-search-backward
function first-tab () {
    [ $#BUFFER = 0 ] && {
        BUFFER="cd "
        CURSOR=3
        zle list-choices
    } || {
        zle expand-or-complete
    }
}
zle -N first-tab
bindkey '^I' first-tab


