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
