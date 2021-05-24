autoload -U compinit
compinit
zstyle ':completion:*' completer _expand_alias _complete _ignored _approximate _correct
zstyle ':completion:*:approximate:*' max-errors 5
