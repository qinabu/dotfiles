# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#Version-Control-Information
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
# hook for update vcs_info
add-zsh-hook -Uz precmd vcs_info
# precmd() { vcs_info }

# enable substitution in PROMPT and PS1
setopt prompt_subst

zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '

zstyle ':vcs_info:*' formats       ' GIT, BABY! [%b]'
zstyle ':vcs_info:*' actionformats ' GIT ACTION! [%b|%a]'

PS1=''
# last exit code
PS1+='%(?||%K{red}%F{black}[%?]%f%k )'
# directory
PS1+='%F{blue}%(5~|%-1~/../%3~|%4~)%f '
# git
PS1+='${vcs_info_msg_0_}%f%# $myvar $pipestatus '

