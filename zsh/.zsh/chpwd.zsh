[[ $TERM_PROGRAM == "iTerm.app" ]] && {
        iterm_chpwd() 
        {
                # [[ "$SHLVL" -lt 2 ]]
                local d
                [[ "$PWD" == "$HOME" ]] && d="~" || d=$(basename "$PWD")
                printf "\033]0;${d}\007"
        }

        iterm_chpwd_unreg()
        {
                iterm_chpwd
                add-zsh-hook -d precmd iterm_chpwd
                add-zsh-hook -d preexec iterm_chpwd_unreg
        }

        autoload -Uz add-zsh-hook
        add-zsh-hook chpwd iterm_chpwd
        add-zsh-hook precmd iterm_chpwd
        add-zsh-hook preexec iterm_chpwd_unreg
}
