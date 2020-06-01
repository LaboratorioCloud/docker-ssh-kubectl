FROM ubuntu:20.10


#######
# SSH #
#######
RUN apt-get update && apt-get install -y openssh-server curl  \
    && mkdir /var/run/sshd  \
    && echo 'root:THEPASSWORDYOUCREATED' | chpasswd  \
    && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

###########
# KUBECTL #
###########
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
    && chmod +x ./kubectl \
    && mv ./kubectl /usr/local/bin/kubectl

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
