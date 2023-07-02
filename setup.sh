rm -rf $HOME/.config/git
rm -rf $HOME/.config/clangd
rm -rf $HOME/.config/pip
rm -rf $HOME/.config/conda
rm -rf $HOME/.config/tmux
rm -rf $HOME/.tmux.conf

mkdir -p $HOME/.config/tmux

ln -s `pwd`/Setting-for-Mac/config/* $HOME/.config
ln -s `pwd`/Setting-for-Mac/.tmux.conf $HOME/

git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
bash ~/.config/tmux/plugins/tpm/bin/install_plugins
