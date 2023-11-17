# Setting-for-Mac

Run the following commands to create soft links to your home directory. Of course, you can check the `setup.sh` before you run it. The `setup.sh` is modularized, you can comment out the modules you don't want to run.

## install oh my zsh first

```bash
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh > install.sh
ZSH=$HOME/.config/oh-my-zsh sh install.sh
rm install.sh
```

## setup script

```bash
zsh setup.sh
```

