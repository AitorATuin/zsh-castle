# Set options

setopt appendhistory \
    autocd \
    extendedglob \
    nomatch \
    notify \
    prompt_subst \
    hist_ignore_space

unsetopt beep

fpath+=~/.zsh/completions
fpath+=~/.zsh/autoload
fpath+=~/.zprompts

# autoload some stuff
zstyle ':completion:*' menu select
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)*==34=34}:${(s.:.)LS_COLORS}")'

autoload -Uz promptinit && promptinit
prompt atuin

autoload -Uz bashcompinit && bashcompinit

# Custom autoload functions
autoload cdg \
    lss \
    lsp \
    tardir \
    bandcamp-dl \
    watch-ss

# Colors by name - based on https://github.com/Tarrasch/zsh-colors
colors=(black red green yellow blue magenta cyan white)
autoload -Uz $colors
autoload -U colors && colors

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


