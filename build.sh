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

tee /etc/yum.repos.d/vscode.repo <<'EOF'
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF

tee /etc/yum.repos.d/ublue-staging.repo <<'EOF'
[copr:copr.fedorainfracloud.org:ublue-os:staging]
name=Copr repo for staging owned by ublue-os
baseurl=https://download.copr.fedorainfracloud.org/results/ublue-os/staging/fedora-$releasever-$basearch/
type=rpm-md
skip_if_unavailable=True
gpgcheck=1
gpgkey=https://download.copr.fedorainfracloud.org/results/ublue-os/staging/pubkey.gpg
repo_gpgcheck=0
enabled=1
enabled_metadata=1
EOF

tee /etc/yum.repos.d/nordvpn.repo <<'EOF'
[nordvpn]
name = NordVPN YUM repository - $basearch
baseurl = https://repo.nordvpn.com/yum/nordvpn/centos/$basearch
enabled = 1
gpgcheck = 0
gpgkey = file:///etc/pki/rpm-gpg/RPM-GPG-KEY-NordVPN

[nordvpn-noarch]
name = NordVPN YUM repository - noarch
baseurl = https://repo.nordvpn.com/yum/nordvpn/centos/noarch
enabled = 1
gpgcheck = 0
gpgkey = file:///etc/pki/rpm-gpg/RPM-GPG-KEY-NordVPN
EOF



RELEASE="$(rpm -E %fedora)"

rpm-ostree install https://repo.nordvpn.com/yum/nordvpn/centos/noarch/Packages/n/nordvpn-release-1.0.0-1.noarch.rpm

PACKAGES_TO_INSTALL=(
    nordvpn
    bootc
    containerd.io
    docker-buildx-plugin
    docker-ce
    docker-ce-cli
    docker-compose-plugin
    virt-install
    libvirt-daemon-config-network
    libvirt-daemon-kvm
    qemu-kvm
    qemu-char-spice
    qemu-device-display-virtio-gpu
    qemu-device-display-virtio-vga
    qemu-device-usb-redirect
    qemu-img
    qemu-system-x86-core
    adw-gtk3-theme
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
    zsh
    code
    ptyxis
    nautilus-open-any-terminal
)




### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
rpm-ostree install "${PACKAGES_TO_INSTALL[@]}"

rpm-ostree override remove \
    firefox-langpacks firefox

#### System unit file
systemctl enable podman.socket
systemctl enable docker.socket
systemctl enable libvirtd


### Add brew
curl -fsSL "https://raw.githubusercontent.com/ublue-os/bluefin/refs/heads/main/build_files/brew.sh" | bash
