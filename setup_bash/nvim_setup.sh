#!/bin/bash
########################################
# Fedora-43 for WSL + atcoder + neovim #
########################################

cd
#更新 ##########################################
sudo dnf -y update && sudo dnf -y upgrade
#neovim ########################################
sudo dnf -y group install development-tools
<<<<<<< HEAD
sudo dnf -y install \
    gcc-c++ \
    neovim \
    fd-find \
    ripgrep \
    nodejs-npm \
    wl-clipboard \
    sqlite sqlite-devel sqlite-tcl
sudo npm install -g tree-sitter-cli
=======
sudo dnf -y install gcc-c++ \
fd-find \
ripgrep \
sqlite sqlite-devel sqlite-tcl \
nodejs-npm
sudo npm install -g tree-sitter-cli #treesitter
>>>>>>> origin/HEAD

# Neovim 最新パッケージインストール (dnfが対応次第置き換える)############
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage
./nvim-linux-x86_64.appimage --appimage-extract
rm nvim-linux-x86_64.appimage
sudo mv squashfs-root/ /opt/nvim/
sudo ln -s /opt/nvim/AppRun /usr/bin/nvim
<<<<<<< HEAD

###############################################
#その他ツール
sudo dnf -y install \
    tmux \
    gh
=======
######################################################################
#tmux
sudo dnf -y install tmux
#github
sudo dnf -y install gh
#wslクリップボード
sudo dnf -y install wl-clipboard 
>>>>>>> origin/HEAD

#Rust Iced GUI libX11 ###################################
#Xserver
#sudo dnf -y install libX11-devel
#sudo dnf -y install libXext-devel
#sudo dnf -y install libXcursor-devel
#sudo dnf -y install libXi-devel
#sudo dnf -y install libXrandr-devel
#sudo dnf -y install mesa-libGL-devel
#sudo dnf -y install  mesa-libEGL-devel
# 入力系
#sudo dnf -y install libxkbcommon-x11
#sudo dnf -y install libxkbcommon-devel
#sudo dnf -y install libxkbcommon-x11-devel
#IME
#sudo dnf -y install fcitx5
#sudo dnf -y install fcitx5-mozc
#sudo dnf -y install dbus-x11
#そのままでは使えないので以下のurl手順を実行
#https://github.com/microsoft/WSL/issues/10205#issuecomment-2198582165
#全角半角キー連打を解消
#sudo dnf -y install xset
#sudo xset -r 49
# fcitx5-configtoolでmzucに設定

#atcoder ##############################################
sudo dnf -y install \
    openssl-devel \
    jq
sudo dnf -y copr enable wslutilities/wslu fedora-41-x86_64
sudo dnf -y install wslu
#################################################

#setup ##############################################################################
git clone --filter=blob:none --no-checkout https://github.com/yaburin1/.setup.git
cd .setup
git sparse-checkout init --no-cone
# pull file #####################################################################
git sparse-checkout set nvim/* tmux/.tmux.conf .gitignore atcoder/* bash/* /git/.gitconfig /setup_bash/nvim_setup.sh
#################################################################################
git checkout main
sudo cp -r /mnt/e/.setup/.ssh/ ~/
# ファイル配置(シンボリックリンク) #####################################################
mkdir ~/.config
ln -snf ~/.setup/git/.gitconfig ~/.gitconfig
ln -snf ~/.setup/nvim/ ~/.config
ln -snf ~/.setup/tmux/.tmux.conf ~/
ln -snf ~/.setup/bash/.bashrc ~/.bashrc
ln -snf ~/.setup/bash/.dircolors ~/.dircolors
# rust #################################################################
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source ~/.bashrc
# atcoder ##############################################################
cargo install cargo-compete
rustup toolchain install 1.89.0-x86_64-unknown-linux-gnu
mkdir ~/atcoder
cd ~/atcoder
echo "2" | cargo compete init atcoder
ln -snf ~/.setup/atcoder/* ~/atcoder
sudo tee -a /etc/wsl.conf <<EOF
[interop]
enabled = true
appendWindowsPath = true
EOF
#########################################################################

