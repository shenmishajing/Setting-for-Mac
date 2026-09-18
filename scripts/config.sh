#!/usr/bin/env zsh
# Link configuration files from this repository into their live locations.
set -e

REPO=$(cd "$(dirname "$0")/.." && pwd)

# Replace $2 with a symlink to $1. An existing real file or directory is moved
# aside as $2.bak instead of being deleted.
link() {
  local src=$1 dst=$2
  if [[ -L $dst ]]; then
    rm "$dst"
  elif [[ -e $dst ]]; then
    mv "$dst" "$dst.bak"
  fi
  ln -s "$src" "$dst"
}

# XDG configs: ~/.config/<name> -> config/<name>
mkdir -p "$HOME/.config"
for name in git clangd pip conda zsh nvim; do
  link "$REPO/config/$name" "$HOME/.config/$name"
done

# Claude Code: ~/.claude/<item> -> config/claude/<item>
# Code-bearing skills are git submodules under config/claude/skills.
git -C "$REPO" submodule update --init --recursive
mkdir -p "$HOME/.claude"
for item in settings.json rules skills; do
  link "$REPO/config/claude/$item" "$HOME/.claude/$item"
done
