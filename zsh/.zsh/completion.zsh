autoload -U compinit
compinit
zstyle ':completion:*' completer _expand_alias _complete _ignored _approximate _correct
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:approximate:*' max-errors 5 not-numeric
