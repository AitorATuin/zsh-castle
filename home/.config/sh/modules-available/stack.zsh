# Stack plugin

which stack >/dev/null && {
    eval "$(stack --bash-completion-script stack)"
    alias ghc='stack exec -- ghc'
    alias ghci='stack exec -- ghci'
}

