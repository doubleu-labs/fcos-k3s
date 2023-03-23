FROM quay.io/fedora/fedora-coreos:stable

ARG K3S_VERSION=v1.25.7+k3s1
ARG BUNDLE=false
ARG TARGETARCH

RUN rpm-ostree install https://github.com/k3s-io/k3s-selinux/releases/download/v1.3.testing.4/k3s-selinux-1.3-4.coreos.noarch.rpm && \
    rpm-ostree cleanup -m

COPY install-k3s.sh /usr/bin/

RUN mkdir /usr/libexec/k3s && \
    curl -# -L https://raw.githubusercontent.com/k3s-io/k3s/${K3S_VERSION}/install.sh -o /usr/libexec/k3s/install.sh && \
    chmod +x /usr/libexec/k3s/install.sh

RUN if [ ${BUNDLE} == true ]; then \
        cd /usr/libexec/k3s/ && \
        case $TARGETARCH in \
            amd64) SUFFIX='' ;; \
            arm64) SUFFIX='-arm64' ;; \
            s390x) SUFFIX='-s390x' ;; \
        esac && \
        curl -# -LO https://github.com/k3s-io/k3s/releases/download/${K3S_VERSION}/k3s${SUFFIX} && \
        curl -# -L -o - https://github.com/k3s-io/k3s/releases/download/${K3S_VERSION}/k3s-airgap-images-${TARGETARCH}.tar.gz | \
            gunzip > k3s-airgap-images-${TARGETARCH}.tar && \
        curl -# -L -o - https://github.com/k3s-io/k3s/releases/download/${K3S_VERSION}/sha256sum-${TARGETARCH}.txt | \
            sha256sum --check --ignore-missing && \
        if [ "k3s${SUFFIX}" != "k3s" ]; then \
            mv k3s${SUFFIX} k3s; \
        fi && \
        chmod +x k3s && \
        sed -i '/^#export INSTALL_K3S_SKIP_DOWNLOAD/s/^#//' /usr/bin/install-k3s.sh ; \
    fi

RUN ostree container commit
