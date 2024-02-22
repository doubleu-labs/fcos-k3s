FROM quay.io/fedora/fedora-coreos:stable

COPY rancher-k3s-common-stable.repo /etc/yum.repos.d/
RUN rpm-ostree install k3s-selinux && \
    rpm-ostree cleanup -m

COPY --chmod=744 k3s/install.sh /usr/libexec/k3s/
COPY install-k3s.sh /usr/bin/

RUN ostree container commit
