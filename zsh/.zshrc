set -o pipefail
setopt interactivecomments

export LC_ALL=en_US.UTF-8
export LC_CTYPE=UTF-8

autoload -U add-zsh-hook
autoload run-help
autoload -Uz vcs_info
autoload -U compinit
autoload -z edit-command-line
zle -N edit-command-line

### HISTORY

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000000
SAVEHIST=100000000
setopt share_history



### VIM MODE

bindkey -v
bindkey -M vicmd '^E' edit-command-line
bindkey -M viins '^E' edit-command-line

bindkey "^W" backward-kill-word
bindkey "^H" backward-delete-char      # Control-h also deletes the previous char
bindkey "^U" backward-kill-line

bindkey -M viins '^A' beginning-of-line
# bindkey -M viins '^E' end-of-line # edit in $EDITOR
bindkey -M viins '^H' backward-delete-char
bindkey -M viins "^?" backward-delete-char
bindkey -M viins '^P' up-history
bindkey -M viins '^N' down-history
bindkey -M viins '^D' delete-char-or-list
bindkey -M viins '^B' backward-char
bindkey -M viins '^F' forward-char
bindkey -M viins '^K' kill-line
bindkey -M viins '^R' history-incremental-search-backward
bindkey -M viins '^S' history-incremental-search-forward
bindkey -M viins '^U' backward-kill-line
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^Y' yank
bindkey -M viins '^_' undo

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

unalias run-help 2>/dev/null || true
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
# " (%s)-[%b]%u%c-" 
# actionformats
# " (%s)-[%b|%a]%u%c-" 

zstyle ':vcs_info:*' unstagedstr ' %F{1}*%f' # %u
zstyle ':vcs_info:*' stagedstr ' %F{2}+%f' # %c
zstyle ':vcs_info:*' actionformats '%F{2}%b %F{10}%a%f%u%c' # branch merge/rebase
zstyle ':vcs_info:*' formats '%F{2}%b%f%u%c' # branch

PS1='%F{238}▗%f%K{238} ' # <
PS1+='%(?||%K{1}%F{7} ${${pipestatus[@]}// /|} %f%k%K{238} )' # last exit codes (requires set -o pipefail)
PS1+='%F{3}%(5~|%-1~/../%3~|%4~)%f' # directory
PS1+='%F{10}${vcs_tags:+ }${vcs_tags}${vcs_info_msg_0_:+ }${vcs_info_msg_0_}%f' # ⁄❯ vcs_info
PS1+=' %k%F{238}▘%f ' # >


# PS1='%F{8}(%f '
# PS1+='%(?||%K{88}%F{7} ${${pipestatus[@]}// /|} %f%k )' # last exit codes (requires set -o pipefail)
# PS1+='%F{3}%(5~|%-1~/../%3~|%4~)%f' # directory
# PS1+='${vcs_tags:+ }%F{5}${vcs_tags}%f${vcs_info_msg_0_:+ }${vcs_info_msg_0_} %F{8})%f ' # ⁄❯ vcs_info


### COMPLETION

compinit

# setopt MENU_COMPLETE

# # matches case insensitive for lowercase
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# # pasting with tabs doesn't perform completion
# zstyle ':completion:*' insert-tab pending

# # default to file completion
# # zstyle ':completion:*' completer _expand_alias _expand _complete _files _correct _approximate
# zstyle ':completion:*' _expand_alias _expand _complete _correct _approximate

# # zstyle ':completion:*' verbose yes
# # zstyle ':completion:*' squeeze-slashes true
# zstyle ':completion:*' complete-options true


## menu-style
autoload -Uz compinit && compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true
# case insensitive
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# Tab completion colors
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# add new installed packages into completions
zstyle ':completion:*' rehash true
# Use better completion for the kill command
#zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;34'
#zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
# use completion cache
zstyle ':completion::complete:*' use-cache true

bindkey "^Xa" _expand_alias
zstyle ':completion:*' completer _expand_alias _expand _complete _correct _approximate
zstyle ':completion:*' regular true




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
	# clear
}
bindkey -M viins -s '^f' 'lfcd\n'
# bindkey -s '^f' 'lfcd\n'
bindkey -s '^k' 'lfcd\n'



### PATH

[[ -z "$PATH_" ]] && {
	export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
	export PATH="/usr/local/opt/curl/bin:$PATH"

	export PATH=$PATH:/usr/local/sbin
	export PATH=$PATH:~/.zsh/scripts
	export PATH=$PATH:~/.local/bin

	export GOPATH=$HOME/.local/share/go/
	export PATH=$PATH:~/.local/share/go/bin

	export PATH_=1
}

alias s="git status --short"



# EDITOR
export EDITOR=nvim
export PAGER=less



# ALIASES
alias ls="gls --group-directories-first"
alias ll="gls --group-directories-first -l -F -X"
alias la="gls --group-directories-first -l -F -X -A"
alias e="$EDITOR"
alias -g E="|$EDITOR"
alias -g less="less -i"
alias -g LL="2>&1 |less -i"
alias -g LLN="2>&1 |less -i -N"
alias -g GG="2>&1 |grep "
alias -g PB="2>&1 |pbcopy"
alias v="vim"
alias n="nvim"

git_reset() { [[ -n "$@" ]] && git reset $@; }
git_fetch() { [[ -n "$@" ]] && git fetch $@; }
git_checkout() {
	[[ -n "$@" ]] && git checkout "$@" || {
		local b=$(git branch --all | fzf | sed 's#^[\* ]*##')
		[[ -z "$b" ]] && return 0
		echo "$b" | grep "^remotes/" > /dev/null && {
			local rb=$(sed 's#^remotes/##' <<< "$b")
			local lb=$(sed 's#^remotes/[^/]*/##' <<< "$b")
			git checkout -b "$lb" --track "$rb"
		} || {
			git checkout "$b"
		}
	}
}

alias s="git status --short --branch"
alias a="git add"
alias c="git commit"
alias ca="git commit --amend --no-edit"
alias cae="git commit --amend"
alias cb='CB=$(git rev-parse --abbrev-ref HEAD | grep -Eo "\w+-\d+") && git commit --template <(echo "$CB ")'
alias d="git diff --stat -U"
alias p="git push"
alias pu="git pull"
alias poh="p origin head"
alias b="git branch -vv --sort '-committerdate'"
alias t="git tag | sort -Vr"
alias re="git tag -l release* | sort -r"
alias r=git_reset
alias f=git_fetch
alias ch=git_checkout

alias al="tig --all"
alias l="tig"
alias lmy="git log --oneline --author=\$(git config user.email) --stat"

alias evald='eval $(minikube docker-env)'

alias av="aws-vault"
alias ave="aws-vault exec"
alias avl="aws-vault login"

_fzf_complete_aws-vault() {
  _fzf_complete --multi --reverse -- "$@" < <(
    aws-vault list --profiles
  )
}


# PROFILE & envs
export GPG_TTY=$(tty)

source ~/.profile &>/dev/null || true

