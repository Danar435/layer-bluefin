#!/bin/bash

set -ouex pipefail

### Enable repositories

dnf5 -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf5 -y install https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf5 -y copr enable faugus/faugus-launcher

### Install packages

dnf5 -y install steam gamescope gamemode mangohud
dnf5 -y install faugus-launcher waydroid

### Cleaning up

dnf5 -y remove rpmfusion-free-release
dnf5 -y remove rpmfusion-nonfree-release
dnf5 -y copr disable faugus/faugus-launcher

### Install vscode

#tee /etc/yum.repos.d/vscode.repo <<'EOF'
#[code]
#name=Visual Studio Code
#baseurl=https://packages.microsoft.com/yumrepos/vscode
#enabled=1
#gpgcheck=1
#gpgkey=https://packages.microsoft.com/keys/microsoft.asc
#EOF
#sed -i "s/enabled=.*/enabled=0/g" /etc/yum.repos.d/vscode.repo
#dnf5 -y install --enablerepo=code code

### Setup aliases

play() {
    MANGOHUD=1 gamemoderun gamescope -W 1920 -H 1080 -f -- "$@"
}
play-fsr() {
    MANGOHUD=1 gamemoderun gamescope -W 1920 -H 1080 -f -F fsr -- "$@"
}
play-int() {
    MANGOHUD=1 gamemoderun gamescope -W 1920 -H 1080 -f -F nearest -S integer -- "$@"
}

### Better ujust

UJUST_PATH="/usr/share/ublue-os/justfile"
sed -i 's/@{{ just }} --list/@{{ just }} --choose/g' "$UJUST_PATH"
