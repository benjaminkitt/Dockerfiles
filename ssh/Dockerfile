FROM node:0.12
MAINTAINER Benjamin Kitt "benjamin@benjaminkitt.com"

# Install and configure ssh
RUN apt-get update && \
    apt-get -y install openssh-server pwgen sudo && \
    mkdir -p /var/run/sshd && \
    sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation yes/g" /etc/ssh/sshd_config && \
    sed -i "s/PermitRootLogin without-password/PermitRootLogin no/g" /etc/ssh/sshd_config

ADD run.sh /run.sh
RUN chmod +x /*.sh

ENV USER user
ENV AUTHORIZED_KEYS **None**

EXPOSE 22
CMD ["/run.sh"]