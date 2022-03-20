# source ~/.zsh/zshrc

### COMMON

set -o pipefail

autoload -U add-zsh-hook
autoload run-help
autoload -Uz vcs_info
autoload -U compinit

### HISTORY

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000000
SAVEHIST=100000000
setopt share_history



### VIM MODE

bindkey -v
# bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^P' up-history
bindkey -M viins '^N' down-history
bindkey -M viins "^?" backward-delete-char

bindkey "^W" backward-kill-word
bindkey "^H" backward-delete-char      # Control-h also deletes the previous char
bindkey "^U" backward-kill-line

export KEYTIMEOUT=2 # 20ms
export VI_MODE_SET_CURSOR=true


# Change cursor with support for inside/outside tmux
function _set_cursor() { echo -ne $1; [[ -n $TMUX ]] && echo -ne "\ePtmux;\e\e$1\e\\" }
function _set_block_cursor() { _set_cursor '\e[2 q' }
function _set_beam_cursor() { _set_cursor '\e[6 q' }

function zle-keymap-select {
  if [[ ${KEYMAP} == "vicmd" ]] || [[ $1 = 'block' ]]; then
      _set_block_cursor
  else
      _set_beam_cursor
  fi
}
zle -N zle-keymap-select
# ensure beam cursor when starting new terminal
# add-zsh-hook -Uz preexec _set_beam_cursor 
add-zsh-hook -Uz precmd _set_beam_cursor 
# ensure insert mode and beam cursor when exiting vim
zle-line-init() { zle -K viins; _set_beam_cursor }



### HELP

unalias run-help
alias help=run-help



### FZF

brew_prefix=$(brew --prefix)
fzf_completion_zsh="${brew_prefix}/opt/fzf/shell/completion.zsh"
fzf_key_bindings_zsh="${brew_prefix}/opt/fzf/shell/key-bindings.zsh"
if [[ $- == *i* && -f "$fzf_key_bindings_zsh" ]]; then
	source "$fzf_completion_zsh" 2> /dev/null \
	&& source "$fzf_key_bindings_zsh" 2> /dev/null \
	&& {
		bindkey "^I" fzf-completion
		bindkey "^R" fzf-history-widget
		bindkey "^T" fzf-file-widget
		bindkey "^[c" fzf-cd-widget
	}
fi



### PROMPT

set -o pipefail

# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#Version-Control-Information
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' check-for-staged-changes true
# hook for update vcs_info
add-zsh-hook -Uz precmd vcs_info
function vcs_info_tags() { vcs_tags=$(git tag --points-at HEAD 2>&- | xargs) }
add-zsh-hook -Uz precmd vcs_info_tags 
# precmd() { vcs_info }

# enable substitution in PROMPT and PS1
setopt prompt_subst

# formats
#     " (%s)-[%b]%u%c-" 
# actionformats
#     " (%s)-[%b|%a]%u%c-" 

zstyle ':vcs_info:*' unstagedstr ' %F{1}~%f' # %u
zstyle ':vcs_info:*' stagedstr ' %F{2}+%f' # %c
zstyle ':vcs_info:*' actionformats '%F{2}%b %F{22}%a%f%u%c' # branch merge/rebase
zstyle ':vcs_info:*' formats '%F{2}%b%f%u%c' # branch

PS1=''
PS1+='%(?||%K{88}%F{7} ${${pipestatus[@]}// /|} %f%k )' # last exit codes (requires set -o pipefail)
PS1+='%F{3}%(5~|%-1~/../%3~|%4~)%f' # directory
PS1+='${vcs_tags:+ }%F{5}${vcs_tags}%f${vcs_info_msg_0_:+ }${vcs_info_msg_0_} %F{0}❯%f ' # vcs_info



### COMPLETION

compinit

# matches case insensitive for lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# pasting with tabs doesn't perform completion
zstyle ':completion:*' insert-tab pending

# default to file completion
zstyle ':completion:*' completer _expand _complete _files _correct _approximate



### PATH

PATH=$PATH:~/.zsh/scripts
PATH=$PATH:~/.local/bin
PATH=$PATH:/usr/local/go/bin



### LF browser

lfcd () {
    f=~/.cache/lfcd
    touch "$f"
    lf -last-dir-path="$f" "$@"
    if [ -f "$f" ]; then
        d="$(cat "$f")"
        # rm -f "$f"
        if [ -d "$d" ]; then
            if [ "$d" != "$(pwd)" ]; then
                cd "$d"
            fi
        fi
    fi
    clear
}
bindkey -M viins -s '^f' 'lfcd\n'  # zsh
bindkey -s '^f' 'lfcd\n'  # zsh



source ~/.profile
