rm -rf $HOME/.config/git
rm -rf $HOME/.config/clangd
rm -rf $HOME/.config/pip
rm -rf $HOME/.config/conda
rm -rf $HOME/.config/zsh

ln -s `pwd`/config/* $HOME/.config

