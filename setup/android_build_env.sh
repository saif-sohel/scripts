#!/usr/bin/env bash

# Copyright (C) 2018 Harsh 'MSF Jarvis' Shandilya
# Copyright (C) 2018 Akhil Narang
# SPDX-License-Identifier: GPL-3.0-only

# Script to setup an AOSP Build environment on Ubuntu and Linux Mint

bash "$(dirname "$0")"/platform-tools.sh

LATEST_MAKE_VERSION="4.4.1"
LATEST_CCACHE_VERSION="4.10.1"

sudo apt install software-properties-common -y
sudo apt update

# Install lsb-core packages
sudo apt install lsb-release -y

LSB_RELEASE="$(lsb_release -d | cut -d ':' -f 2 | sed -e 's/^[[:space:]]*//')"

sudo DEBIAN_FRONTEND=noninteractive \
    apt install \
    autoconf automake axel bc bison build-essential \
    clang cmake curl expat flex g++ \
    g++-multilib gawk gcc gcc-multilib git git-lfs gnupg gperf \
    htop imagemagick lib32ncurses-dev lib32z1-dev libtinfo6 libc6-dev libcap-dev \
    libexpat1-dev libgmp-dev '^liblz4-.*' '^liblzma.*' libmpc-dev libmpfr-dev libncurses-dev \
    libsdl1.2-dev libssl-dev libtool libxml2 libxml2-utils '^lzma.*' lzop \
    maven ncftp ncurses-dev patch patchelf pkg-config pngcrush \
    pngquant python3.12 python3-all-dev re2c schedtool squashfs-tools subversion \
    texinfo unzip w3m xsltproc zip zlib1g-dev lzip \
    libxml-simple-perl libswitch-perl apt-utils rsync \
    libncurses6 curl python-is-python3 -y

echo "Updating python symbolic link"
sudo ln -sf /usr/bin/python3.12 /usr/bin/python3

echo -e "Setting up udev rules for adb!"
sudo curl --create-dirs -L -o /etc/udev/rules.d/51-android.rules -O -L https://raw.githubusercontent.com/richardqcarvalho/android-udev-rules/master/51-android.rules
sudo chmod 644 /etc/udev/rules.d/51-android.rules
sudo chown root /etc/udev/rules.d/51-android.rules
sudo systemctl restart udev

if [[ "$(command -v make)" ]]; then
    makeversion="$(make -v | head -1 | awk '{print $3}')"
    if [[ ${makeversion} != "${LATEST_MAKE_VERSION}" ]]; then
        echo "Installing make ${LATEST_MAKE_VERSION} instead of ${makeversion}"
        bash "$(dirname "$0")"/make.sh "${LATEST_MAKE_VERSION}"
    fi
fi

echo "Installing repo"
sudo curl --create-dirs -L -o /usr/local/bin/repo -O -L https://storage.googleapis.com/git-repo-downloads/repo
sudo chmod a+rx /usr/local/bin/repo

echo "Installing ccache"
bash "$(dirname "$0")"/ccache.sh "${LATEST_CCACHE_VERSION}"

echo "Adding workaround to avoid nsjail error"
echo "kernel.apparmor_restrict_unprivileged_userns=0" | sudo tee /usr/lib/sysctl.d/10-apparmor.conf
