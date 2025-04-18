#!/bin/bash

set -ouex pipefail

tee /etc/yum.repos.d/nordvpn.repo <<'EOF'
[nordvpn]
name=nordvpn
enabled=1
gpgcheck=0
baseurl=https://repo.nordvpn.com/yum/nordvpn/centos/x86_64
EOF

RELEASE="$(rpm -E %fedora)"

PACKAGES_TO_INSTALL=(
    nordvpn
    bridge-utils
    gtk2-devel
    xhost
    foot
)

# Install necessary packages
dnf install -y "${PACKAGES_TO_INSTALL[@]}"

# Remove unwanted packages
dnf remove -y \
    nvtop ptyxis tailscale solaar simple-scan gnome-shell-extension-search-light gnome-shell-extension-tailscale-gnome-qs

curl -fsSL "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/build_files/base/10-brew.sh" | bash
