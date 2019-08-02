rm -rf $HOME/.clang-format
rm -rf $HOME/.condarc
rm -rf $HOME/.gdbinit
rm -rf $HOME/.gitconfig
rm -rf $HOME/.gitignore_global
rm -rf $HOME/.tmux.conf
rm -rf $HOME/.pip

ln -s `pwd`/Setting-for-Mac/.clang-format $HOME/
ln -s `pwd`/Setting-for-Mac/.condarc $HOME/
ln -s `pwd`/Setting-for-Mac/.gdbinit $HOME/
ln -s `pwd`/Setting-for-Mac/.gitconfig $HOME/
ln -s `pwd`/Setting-for-Mac/.gitignore_global $HOME/
ln -s `pwd`/Setting-for-Mac/.tmux.conf $HOME/
ln -s `pwd`/Setting-for-Mac/.pip $HOME/

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
bash ~/.tmux/plugins/tpm/bin/install_plugins
