#!/bin/bash

set -eoux pipefail

# Enable nullglob for all glob operations to prevent failures on empty matches

shopt -s nullglob

# Copy system files, brewfiles, justfiles and flatpak preinstall files

cp -r /ctx/system_files/* /
mkdir -p /usr/share/ublue-os/homebrew/
cp /ctx/custom_files/brew/*.Brewfile /usr/share/ublue-os/homebrew/
find /ctx/custom_files/ujust -iname '*.just' -exec printf "\n\n" \; -exec cat {} \; >> /usr/share/ublue-os/just/60-custom.just
mkdir -p /etc/flatpak/preinstall.d/
cp /ctx/custom_files/flatpaks/*.preinstall /etc/flatpak/preinstall.d/

# Install packages

dnf5 -y install steam gamescope mangohud waydroid gcc-c++

source /ctx/build_files/copr-helpers.sh
copr_install_isolated "faugus/faugus-launcher" faugus-launcher
copr_install_isolated "lizardbyte/beta" sunshine

### Install vscode

#cat > /etc/yum.repos.d/vscode.repo << 'EOF'
#[code]
#name=Visual Studio Code
#baseurl=https://packages.microsoft.com/yumrepos/vscode
#enabled=1
#gpgcheck=1
#gpgkey=https://packages.microsoft.com/keys/microsoft.asc
#EOF
#dnf5 -y install --enablerepo=code code
#rm -f /etc/yum.repos.d/vscode.repo

### Setup sunshine

setcap 'cap_sys_admin+p' $(readlink -f /usr/bin/sunshine)

# Restore default glob behavior

shopt -u nullglob