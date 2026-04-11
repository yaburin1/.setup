#!/bin/bash
########################################
# Fedora-43 for WSL + atcoder + neovim #
########################################

cd
#更新 ##########################################
sudo dnf -y update && sudo dnf -y upgrade
#neovim ########################################
sudo dnf -y group install development-tools
sudo dnf -y install \
    gcc-c++ \
    fd-find \
    ripgrep \
    nodejs-npm \
    wl-clipboard \
    sqlite sqlite-devel sqlite-tcl
sudo npm install -g tree-sitter-cli

# Neovim 最新パッケージインストール (dnfが対応次第置き換える)############
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
chmod u+x nvim-linux-x86_64.appimage
./nvim-linux-x86_64.appimage --appimage-extract
rm nvim-linux-x86_64.appimage
sudo mv squashfs-root/ /opt/nvim/
sudo ln -s /opt/nvim/AppRun /usr/bin/nvim

###############################################
#その他ツール
sudo dnf -y install \
    tmux \
    gh

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
#Rust Iced ##################################
#GPU(WSLg)################################################
sudo dnf install -y vulkan-loader  vulkan-tools
###########vulkanが存在しないデバイスを読まないようにする########
sudo mkdir -p /usr/share/vulkan/icd.d/disabled
cd /user/share/vulkan/icd.d/
sudo mv /usr/share/vulkan/icd.d/*radeon* disabled/
sudo mv /usr/share/vulkan/icd.d/*nouveau* disabled/
sudo mv /usr/share/vulkan/icd.d/*panfrost* disabled/
sudo mv /usr/share/vulkan/icd.d/*freedreno* disabled/
sudo mv /usr/share/vulkan/icd.d/*broadcom* disabled/
sudo mv /usr/share/vulkan/icd.d/*asahi* disabled/
sudo mv /usr/share/vulkan/icd.d/*virtio* disabled/
sudo mv /usr/share/vulkan/icd.d/*powervr* disabled/
sudo mv /usr/share/vulkan/icd.d/*intel_hasvk* disabled/
sudo mv /usr/share/vulkan/icd.d/*intel_icd* disabled/
cd
########もしくは############################################
# export GALLIUM_DRIVER=d3d12
# export MESA_D3D12_DEFAULT_ADAPTER_NAME=NVIDIA
# export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/dzn_icd.x86_64.json
###########################################################

#IME
sudo dnf -y install fcitx5 fcitx5-mozc

#全角半角キー連打を解消
sudo dnf -y install xset
# fcitx5-configtoolでmzucに設定
#
#.cargo/config.tomlに以下を設定
# [env]
# WAYLAND_DISPLAY = { value = "", force = true }
