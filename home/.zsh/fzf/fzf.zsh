# Setup fzf
# ---------
if [[ ! "$PATH" == */home/eof/.fzf/bin* ]]; then
  export PATH="$PATH:/home/eof/.fzf/bin"
fi

# Man path
# --------
if [[ ! "$MANPATH" == */home/eof/.fzf/man* && -d "/home/eof/.fzf/man" ]]; then
  export MANPATH="$MANPATH:/home/eof/.fzf/man"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${FZF_ZSH}/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "${FZF_ZSH}/key-bindings.zsh"

