stow

https://brew.sh/

brew install stow \
alacritty amethyst \
tmux coreutils watch wget 7zip base64 git git-crypt telnet trash \
zsh zsh-syntax-highlighting fd fzf tig glow htop jq jqp yj yq lf ripgrep ccat timg exa bat colordiff chroma tree \
neovim tree-sitter lua luajit luarocks \
go delve golangci-lint \
tfenv tflint opa

brew install --cask nikitabobko/tap/aerospace


fonts

https://madmalik.github.io/mononoki/
https://github.com/mehant-kr/Google-Sans-Mono
https://github.com/be5invis/Iosevka/
https://fonts.google.com/specimen/Martian+Mono
https://github.com/belluzj/fantasque-sans
https://developer.apple.com/fonts/
https://design.ubuntu.com/font/
https://fonts.google.com/specimen/Source+Code+Pro
https://github.com/microsoft/cascadia-code
https://freefontsdownload.net/free-consolas-font-33098.htm

defaults write -g InitialKeyRepeat -int 10 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)


GPG export
gpg --export --armor your@id.here > your@id.here.pub.asc
gpg --export-secret-keys --armor your@id.here > your@id.here.priv.asc
gpg --export-secret-subkeys --armor your@id.here > your@id.here.sub_priv.asc
gpg --export-ownertrust > ownertrust.txt


GPG import
gpg --import your@id.here.pub.asc
gpg --import your@id.here.priv.asc
gpg --import your@id.here.sub_priv.asc
gpg --import-ownertrust ownertrust.txt

gpg --edit-key your@id.here
gpg> trust
Your decision? 5
