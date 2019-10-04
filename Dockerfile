FROM ubuntu:18.04

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
        curl \
        dnsutils \
        host \
        iproute2 \
        iputils-ping \
        less \
        net-tools \
        netcat \
        openssh-server \
        telnet \
        tmux \
        vim \
        wget

# Install kubectl
ARG KUBECTL_VERSION=1.16.1
RUN curl -Lo /usr/local/bin/kubectl \
            https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
        && chmod +x /usr/local/bin/kubectl

# Install helm
ARG HELM_VERSION=2.14.2
RUN curl -Lo /tmp/helm.tar.gz https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
        && tar -C /tmp -zxf /tmp/helm.tar.gz \
        && mv /tmp/linux-amd64/helm /usr/local/bin/helm \
        && rm -rf /tmp/helm.tar.gz /tmp/linux-amd64

RUN mkdir /run/sshd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

ADD entrypoint.sh /entrypoint.sh

ENV UPDATE_ON_START="yes"
ENV ROOT_PASSWORD=""
ENV ROOT_SSH_KEY=""

VOLUME [ "/root" ]
EXPOSE 22

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["/usr/sbin/sshd", "-D"]