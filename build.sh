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
)


# this installs a package from fedora repos
dnf install -y "${PACKAGES_TO_INSTALL[@]}"

dnf remove -y \
    nvtop ptyxis tailscale solaar simple-scan gnome-shell-extension-search-light gnome-shell-extension-tailscale-gnome-qs


curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux \
  --extra-conf "sandbox = false" \
  --no-start-daemon \
  --no-confirm
