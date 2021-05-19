iterm_chpwd() 
{
        # [[ "$SHLVL" -lt 2 ]]
        echo -n -e "\033]0;$(basename $PWD)\007"
}

# iterm_chpwd_reg()
# {
#         add-zsh-hook chpwd iterm_chpwd
#         add-zsh-hook -d precmd iterm_chpwd_reg
#         iterm_chpwd
# }

[[ $TERM_PROGRAM == "iTerm.app" ]] && {
        # autoload -U add-zsh-hook iterm_chpwd
        # add-zsh-hook precmd iterm_chpwd
        add-zsh-hook chpwd iterm_chpwd
        iterm_chpwd
}
