# Set options

setopt appendhistory \
    autocd \
    extendedglob \
    nomatch \
    notify \
    prompt_subst

unsetopt beep

fpath+=~/.zsh/completions
fpath+=~/.zsh/autoload

# autoload some stuff
autoload -Uz compinit; compinit
zstyle :compinstall filename '/Users/atuin/.zshrc'
zstyle ':completion:*' menu select
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)*==34=34}:${(s.:.)LS_COLORS}")'

autoload -Uz promptinit; promptinit

autoload -Uz bashcompinit; bashcompinit

# Custom autoload functions
autoload cdg \
    lss \
    lsp \
    tardir \
    bandcamp-dl

# Keybinding
bindkey -v
bindkey -M vicmd '?' history-incremental-search-backward
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


