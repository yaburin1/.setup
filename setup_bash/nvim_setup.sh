#!/bin/bash

sudo dnf -y update
sudo dnf -y upgrade
sudo dnf -y group install development-tools
sudo dnf -y install gcc-c++
sudo dnf -y install neovim
sudo dnf -y install fd-find
sudo dnf -y install tmux
sudo npm install -g tree-sitter-cli

git config --global core.editor "nvim -w"
git config --global init.defaultBranch main
git_home=$(find ~ -type d -name ".dotfiles" | head -n 1)



mkdir -p "${HOME}/.config"

ln -sfn "${git_home}/.bashrc" "${HOME}/.bashrc"
ln -sfn "${git_home}/.tmux.conf" "${HOME}/.tmux.conf"
ln -sfn "${git_home}/.config/nvim" "${HOME}/.config/nvim"


source "${git_home}/.bashrc"
