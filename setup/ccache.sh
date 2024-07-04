#!/usr/bin/env bash

cd /tmp || exit 1
sudo wget "https://github.com/ccache/ccache/releases/download/v${1:?}/ccache-${1:?}-linux-x86_64.tar.xz"
sudo tar -xvf "ccache-${1:?}-linux-x86_64.tar.xz"
cd "ccache-${1:?}-linux-x86_64"
sudo mv ccache /usr/bin
ccache -M 75G
sudo mkdir -p /mnt/ccache
mkdir -p ~/.cache/ccache
sudo mount --bind "$HOME/.cache/ccache" /mnt/ccache
echo "export USE_CCACHE=1" >> "$HOME/.zshrc"
echo "export CCACHE_EXEC=/usr/bin/ccache" >> "$HOME/.zshrc"
echo "export CCACHE_DIR=/mnt/ccache" >> "$HOME/.zshrc"
echo "$HOME/.cache/ccache /mnt/ccache none defaults,bind,users,noauto 0 0" | sudo tee -a /etc/fstab
echo "mount /mnt/ccache" >> "$HOME/.profile"