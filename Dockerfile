FROM ubuntu:20.10

ARG USER=sysadmin
ARG PW=alterar123
ARG UID=1000
ARG GID=1000

#######
# SSH #
#######
RUN useradd -s /bin/bash -m ${USER} --uid=${UID} && echo "${USER}:${PW}" | \
      chpasswd

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive ; apt-get -q -y install openssh-server vim wget curl sudo \
    && mkdir /var/run/sshd  \
    && chage -d0 sysadmin \
    && echo "sysadmin    ALL=(ALL:ALL) ALL" > /etc/sudoers.d/turmarancher \
    && sed -i 's/PasswordAuthentication.*/PasswordAuthentication yes/'  /etc/ssh/sshd_config

###########
# KUBECTL #
###########
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
