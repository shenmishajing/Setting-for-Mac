rm -rf $HOME/.config/tmux
rm -rf $HOME/.tmux.conf

ln -s `pwd`/.tmux.conf $HOME/

git clone https://github.com/tmux-plugins/tpm $HOME/.config/tmux/plugins/tpm
bash $HOME/.config/tmux/plugins/tpm/bin/install_plugins
