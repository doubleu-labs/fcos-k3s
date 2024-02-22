#!/usr/bin/env bash

export INSTALL_K3S_SKIP_SELINUX_RPM=true

if [ "$INSTALL_K3S_SKIP_DOWNLOAD" = true ]; then
    mkdir -p /var/lib/rancher/k3s/agent/images/
    cp /usr/libexec/k3s/k3s-airgap-images-* /var/lib/rancher/k3s/agent/images
    cp /usr/libexec/k3s/k3s /usr/local/bin/k3s
    chmod +x /usr/local/bin/k3s
fi

/usr/libexec/k3s/install.sh "$@"
