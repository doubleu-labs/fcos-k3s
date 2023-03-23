#!/usr/bin/env bash

export INSTALL_K3S_SKIP_SELINUX_RPM=true
#export INSTALL_K3S_SKIP_DOWNLOAD=true

/usr/libexec/k3s/install.sh "$@"
