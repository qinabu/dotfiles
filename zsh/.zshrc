### ~/.zprofile
### ~/.zshrc <-
### ~/.zlogin

# HOMEBREW_PREFIX is from
# ~/.zprofile: eval "$(/opt/homebrew/bin/brew shellenv)"
HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-}"

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

unalias run-help 2>/dev/null || true
alias help=run-help

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000000
SAVEHIST=100000000
setopt SHARE_HISTORY
setopt HIST_IGNORE_SPACE


###
### PROMPT
###
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

zstyle ':vcs_info:*' unstagedstr '%F{1}*%f ' # %u unstaged
zstyle ':vcs_info:*' stagedstr '%F{2}+%f ' # %c staged
# zstyle ':vcs_info:*' actionformats '%F{10}%a%u%c%f %F{2}%b%f' # branch merge/rebase
zstyle ':vcs_info:*' actionformats '%F{2}%b %F{10}%a%f%u%c' # branch merge/rebase
zstyle ':vcs_info:*' formats '%c%u%F{2}%b%f' # staged(+), unstaged(*), branch
# %s The current version control system, like git or svn.
# %r The name of the root directory of the repository
# %S The current path relative to the repository root directory
# %b Branch information, like master
# %m In case of Git, show information about stashes
# %u Show unstaged changes in the repository
# %c Show staged changes in the repository

PS1='%F{8}▗%f%K{8}' # <
PS1+='%(?|| %K{1}%F{7} ${${pipestatus[@]}// /|} %f%k%K{8})' # last exit codes (requires set -o pipefail)
PS1+='${vcs_info_msg_0_:+ }${vcs_info_msg_0_}%F{14}${vcs_tags:+ }${vcs_tags}%f' # ⁄❯ vcs_info
PS1+=' '
# PS1+='%F{3}%(5~|%-1~/../%3~|%4~)%f' # directory
# PS1+='%F{3}%(4~|%-1~/../%2~|%3~)%f' # directory (relative)
PS1+='%F{3}%1d%f' # directory (last component)
PS1+=' '
PS1+='%k%F{8}▘%f ' # >


###
### VIM MODE
###
edit_nvim() { nvim
	echo -n
	wait
	zle -I || true
	zle-keymap-select
}
zle -N edit_nvim

bindkey -v
bindkey -M vicmd '^E' edit-command-line
bindkey -M viins '^E' edit-command-line
# bindkey -M vicmd '^M' edit_nvim
# bindkey -M viins '^M' edit_nvim

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

# Yank to the system clipboard
function vi-yank-pbcopy {
	zle vi-yank
	CUTBUFFER=$(echo "${CUTBUFFER#$'\n'}")
	echo "${CUTBUFFER%$'\n'}" | pbcopy
}
zle -N vi-yank-pbcopy
bindkey -M vicmd 'y' vi-yank-pbcopy

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


###
### COMPLETION
###
compinit
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


###
### HIGHLIGHTING
###
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" || true

###
### FZF
###
fzf_completion_zsh="${HOMEBREW_PREFIX}/opt/fzf/shell/completion.zsh"
fzf_key_bindings_zsh="${HOMEBREW_PREFIX}/opt/fzf/shell/key-bindings.zsh"
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


###
### EDITOR
###
export EDITOR=nvim
export PAGER=less
export MANPAGER="less -sR --mouse" # man man


###
### ALIASES
###
alias reload='exec $0 "$@"'

alias ls="gls --group-directories-first --color=auto"
alias ll="gls --group-directories-first -l -F -X --color=auto"
alias la="gls --group-directories-first -l -F -X -A --color=auto"
alias -g less="less -i"
alias -g LL="2>&1 |less -i"
alias -g LLN="2>&1 |less -i -N"
alias -g LLR="2>&1 |less -i -R"
alias -g GG="2>&1 |grep "
alias -g PB="2>&1 |pbcopy"
alias -g HH="2>&1 |head"
alias -g NN="2>&1 |nvim"
alias -g CC='2>&1 | ccat -G Plaintext="reset" -G Keyword="darkred" -G Punctuation="faint" -G String="teal" -G Comment="faint" -G Decimal="purple" -G Type="darkgreen" -C "always" |less -i -R'

alias v="vim"
alias n="nvim"
alias m="NVIM_APPNAME=mvim nvim"
alias l="NVIM_APPNAME=lvim nvim"
alias e="$EDITOR"
alias -g EE="|$EDITOR"

# git_reset() { [[ -n "$@" ]] && git reset $@; }
# git_fetch() { [[ -n "$@" ]] && git fetch $@; }
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

git_default_branch () {
        local b=$(cat $(git rev-parse --git-dir 2>/dev/null)/refs/remotes/origin/HEAD 2>/dev/null || true)
        b="${b##*/}"
        echo "${b:-master}"
}

git_commit() {
	short_command "git commit -m " "git commit -v" "$@"
	# if [[ $# -gt 0 ]]; then git commit -m "$*"; else git commit -v; fi
}

git_add() {
	short_command "git add" "git add --all" "$@"
	# if [[ $# -gt 0 ]]; then git add "$@"; else git add --all; fi
}

short_command() {
	local long="$1"
	local short="$2"
	shift 2

	if [[ "$#" -gt 0 ]]; then
		eval "$long $@"
	else
		eval "$short"
	fi
}

alias gal="tig --all"
alias gl="tig"

alias g="git"
alias gc="git_commit"
alias ggc="git gc --prune=now --aggressive && git reflog expire --all --expire=now"
alias gca="git commit --amend"
alias gr="git reset"
alias gs="git status --short --branch"
alias gsu="git diff --name-only --diff-filter=U --relative"
alias gd="g diff --patch-with-stat head"
alias gdc="g diff --patch-with-stat --cached"
alias gdm="g diff --patch-with-stat \$(git_default_branch)"
alias gdmc="g diff --patch-with-stat --cached \$(git_default_branch)"
alias gdom="g diff --patch-with-stat origin/\$(git_default_branch)"
alias gdomc="g diff --patch-with-stat --cached origin/\$(git_default_branch)"

alias gch="git checkout"
alias gchb="git checkout -b"
_fzf_complete_gchb() {
	_fzf_complete --reverse -- "$@" < <(
		which git_checkout_branch >&- && git_checkout_branch
	)
}

alias gu="git pull --tags"
alias gup="git pull --tags -p"
alias gchm="git checkout \$(git_default_branch)"
alias gm="git checkout \$(git_default_branch)"
alias gmm="git checkout \$(git_default_branch) && git pull origin \$(git_default_branch)"
alias gmmp="gmm -p"
alias gf="git fetch"
alias gfo="git fetch origin"
alias gfom="git fetch origin \$(git_default_branch)"
alias gpoh="git push origin head"
alias gpohu="git push origin head -u"
alias gp="gpohu"

alias gmom="git merge origin/\$(git_default_branch)"
alias gmc="git merge --continue"
alias grom="git rebase origin/\$(git_default_branch) -i"
alias grc="git rebase --continue"

alias gcln="git clean -fd"

alias gfm="git fetch origin && git merge origin/\$(git_default_branch)"
alias gfr="git fetch origin && git rebase origin/\$(git_default_branch) -i"

alias ga="git_add"
# alias gcl="git clone --single-branch"
alias gb="git branch"
alias gbs="git branch --sort '-committerdate'"
alias gbsa="git branch --sort '-committerdate' -a"
alias gts="git tag -l --sort=-version:refname"


alias evald='eval $(minikube docker-env)'

alias av="aws-vault"
alias ave="aws-vault exec"
alias avl="aws-vault login"

_fzf_complete_aws-vault() {
  _fzf_complete --reverse -- "$@" < <(
    aws-vault list --profiles
  )
}


###
### LF browser
###
lfcd() {
	local f=~/.cache/lfcd
	touch "$f"
	lf -last-dir-path="$f" "$@"
	if [ -f "$f" ]; then
		d="$(<"$f")"
		# rm -f "$f"
		if [[ -d "$d" && "$d" != "$(pwd)" ]]; then
			cd "$d"
			vcs_info || true
		fi
	fi
	echo -n
	wait
	zle -I || true
	zle-keymap-select
	# clear
}
zle -N lfcd

# bindkey -M viins -s '^f' lfcd
# bindkey -s '^f' lfcd
bindkey '^k' lfcd

# PROFILE & envs
export GPG_TTY=$(tty)


###
### PATH
###
[[ -z "$PATH_" ]] && {
	export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
	export PATH="$HOMEBREW_PREFIX/opt/curl/bin:$PATH"
	export PATH=$PATH:~/.zsh/scripts

	export GOPATH=$HOME/.local/share/go/
	export PATH=$PATH:~/.local/share/go/bin

	export PATH=$PATH:~/.rd/bin

	export PATH_=1
} || true

source ~/.zshrc.work > /dev/null 2>&1 || true
