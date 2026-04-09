#!/bin/bash
cd
#更新 ##########################################
sudo dnf -y update
sudo dnf -y upgrade
#neovim ########################################
sudo dnf -y group install development-tools
sudo dnf -y install gcc-c++
sudo dnf -y install neovim
sudo dnf -y install fd-find #telescope-nvim
sudo dnf -y install ripgrep #smart-open
sudo dnf -y install sqlite sqlite-devel sqlite-tcl #smart-open
sudo dnf -y install nodejs-npm 
sudo npm install -g tree-sitter-cli #treesitter
###############################################
#tmux
sudo dnf -y install tmux
#github
sudo dnf -y install gh
#atcoder #######################################
sudo dnf -y install openssl-devel
sudo dnf -y install jq
sudo dnf -y copr enable wslutilities/wslu fedora-41-x86_64
sudo dnf -y install wslu
#################################################

#setup ##############################################################################
git clone --filter=blob:none --no-checkout https://github.com/yaburin1/.setup.git
cd .setup
git sparse-checkout init --no-cone
# pull file #####################################################################
git sparse-checkout set nvim/* tmux/.tmux.conf .gitignore atcoder/* bash/.bashrc /git/.gitconfig
#################################################################################
git checkout main
# ファイル配置(シンボリックリンク) #####################################################
mkdir ~/.config
ln -snf ~/.setup/git/.gitconfig ~/.gitconfig
ln -snf ~/.setup/nvim/ ~/.config
ln -snf ~/.setup/tmux/.tmux.conf ~/
ln -snf ~/.setup/bash/.bashrc ~/.bashrc
# rust #################################################################
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.bashrc
# atcoder ##############################################################
cargo install cargo-compete
rustup toolchain install 1.89.0-x86_64-unknown-linux-gnu
mkdir ~/atcoder
cd ~/atcoder
echo "2"|cargo compete init atcoder
ln -snf ~/.setup/atcoder/* ~/atcoder
sudo tee -a /etc/wsl.conf<<EOF
[interop]
enabled = true
appendWindowsPath = true
EOF
#########################################################################
