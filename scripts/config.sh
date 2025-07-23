rm -rf $HOME/.config/git
rm -rf $HOME/.config/clangd
rm -rf $HOME/.config/pip
rm -rf $HOME/.config/conda
rm -rf $HOME/.config/zsh
rm -rf $HOME/.config/nvim

ln -s $(pwd)/config/* $HOME/.config
ln -s $(pwd)/claude/* $HOME/.claude
