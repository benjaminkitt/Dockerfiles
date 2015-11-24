#!/bin/bash

if [ "${AUTHORIZED_KEYS}" != "**None**" ]; then
    echo "=> Found authorized keys"
    : ${SSH_USERNAME:=user}
    : ${SSH_USERPASS:=$(dd if=/dev/urandom bs=1 count=15 | base64)}
    useradd -ms /bin/bash -G sudo $SSH_USERNAME
    echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --quiet $SSH_USERNAME)
    echo ssh user password: $SSH_USERPASS
    mkdir -p /home/$SSH_USERNAME/.ssh
    chmod 700 /home/$SSH_USERNAME/.ssh
    chown $SSH_USERNAME:$SSH_USERNAME /home/$SSH_USERNAME/.ssh
    touch /home/$SSH_USERNAME/.ssh/authorized_keys
    chmod 600 /home/$SSH_USERNAME/.ssh/authorized_keys
    chown $SSH_USERNAME:$SSH_USERNAME /home/$SSH_USERNAME/.ssh/authorized_keys
    IFS=$'\n'
    arr=$(echo ${AUTHORIZED_KEYS} | tr "," "\n")
    for x in $arr
    do
        x=$(echo $x |sed -e 's/^ *//' -e 's/ *$//')
        cat /home/$SSH_USERNAME/.ssh/authorized_keys | grep "$x" >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "=> Adding public key to /home/$SSH_USERNAME/.ssh/authorized_keys: $x"
            echo "$x" >> /home/$SSH_USERNAME/.ssh/authorized_keys
        fi
    done
fi

# if [ ! -f /.root_pw_set ]; then
#   /set_root_pw.sh
# fi

exec /usr/sbin/sshd -D