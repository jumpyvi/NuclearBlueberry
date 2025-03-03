#!/bin/bash

set -ouex pipefail

tee /etc/yum.repos.d/docker-ce.repo <<'EOF'
[docker-ce-stable]
name=Docker CE Stable - $basearch
baseurl=https://download.docker.com/linux/fedora/$releasever/$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://download.docker.com/linux/fedora/gpg
EOF

tee /etc/yum.repos.d/wez.repo <<'EOF'
[copr:copr.fedorainfracloud.org:wezfurlong:wezterm-nightly]
name=Copr repo for wezterm-nightly owned by wezfurlong
baseurl=https://download.copr.fedorainfracloud.org/results/wezfurlong/wezterm-nightly/fedora-$releasever-$basearch/
type=rpm-md
skip_if_unavailable=True
gpgcheck=1
gpgkey=https://download.copr.fedorainfracloud.org/results/wezfurlong/wezterm-nightly/pubkey.gpg
repo_gpgcheck=0
enabled=1
enabled_metadata=1
EOF

tee /etc/yum.repos.d/vscode.repo <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

# tee /etc/yum.repos.d/ublue-staging.repo <<'EOF'
# [copr:copr.fedorainfracloud.org:ublue-os:staging]
# name=Copr repo for staging owned by ublue-os
# baseurl=https://download.copr.fedorainfracloud.org/results/ublue-os/staging/fedora-$releasever-$basearch/
# type=rpm-md
# skip_if_unavailable=True
# gpgcheck=1
# gpgkey=https://download.copr.fedorainfracloud.org/results/ublue-os/staging/pubkey.gpg
# repo_gpgcheck=0
# enabled=1
# enabled_metadata=1
# EOF

tee /etc/yum.repos.d/nordvpn.repo <<'EOF'
[nordvpn]
name=nordvpn
enabled=1
gpgcheck=0
baseurl=https://repo.nordvpn.com/yum/nordvpn/centos/x86_64
EOF


RELEASE="$(rpm -E %fedora)"

PACKAGES_TO_INSTALL=(
    wezterm
    nordvpn
    bootc
    containerd.io
    docker-buildx-plugin
    docker-ce
    docker-ce-cli
    docker-compose-plugin
    virt-install
    libvirt
    libvirt-daemon
    libvirt-daemon-config-network
    libvirt-daemon-driver-interface
    libvirt-daemon-driver-network
    libvirt-daemon-driver-nwfilter
    libvirt-daemon-driver-qemu
    libvirt-daemon-driver-secret
    libvirt-daemon-driver-storage-core
    libvirt-daemon-kvm
    bridge-utils
    qemu-kvm
    qemu-char-spice
    qemu-device-display-virtio-gpu
    qemu-device-display-virtio-vga
    qemu-device-usb-redirect
    qemu-img
    edk2-ovmf
    qemu-system-x86-core
    qemu-user-binfmt
    qemu-user-static
    virt-manager
    virt-viewer
    libguestfs-tools
    python3-libguestfs
    virt-top
    podman
    podman-compose
    distrobox
    git-credential-libsecret
    ifuse
    input-remapper
    samba
    code
    gcc
    gtk2-devel
    android-tools 
    xhost
)




### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
rpm-ostree install "${PACKAGES_TO_INSTALL[@]}"

rpm-ostree override remove \
    nvtop

#### System unit file
systemctl enable podman.socket
systemctl enable docker.socket
systemctl enable libvirtd

rm -rf /usr/share/themes

### Add brew
curl -fsSL "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/build_files/base/10-brew.sh" | bash
