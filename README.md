# dotfiles
git clone --recursive https://github.com/joetoth/dotfiles.git

stow dotfiles/

base16 tomorrow-night

curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

# Install Source Code Pro Font
https://github.com/adobe-fonts/source-code-pro/releases
unzip and copy *.otf files to .fonts/ then run fc-cache -f -v

# NeoVim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
:PlugInstall
:UpdateRemote
