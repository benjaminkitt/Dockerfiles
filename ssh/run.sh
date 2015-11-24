#!/bin/bash

if [ "${AUTHORIZED_KEYS}" != "**None**" ]; then
    echo "=> Found authorized keys"
    : ${SSH_USERNAME:=USER}
    : ${SSH_USERPASS:=$(dd if=/dev/urandom bs=1 count=15 | base64)}
    useradd -ms /bin/bash -G sudo $USER
    echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --quiet $USER)
    echo ssh user password: $SSH_USERPASS
    mkdir -p /home/$USER/.ssh
    chmod 700 /home/$USER/.ssh
    chown $USER:$USER /home/$USER/.ssh
    touch /home/$USER/.ssh/authorized_keys
    chmod 600 /home/$USER/.ssh/authorized_keys
    chown $USER:$USER /home/$USER/.ssh/authorized_keys
    IFS=$'\n'
    arr=$(echo ${AUTHORIZED_KEYS} | tr "," "\n")
    for x in $arr
    do
        x=$(echo $x |sed -e 's/^ *//' -e 's/ *$//')
        cat /home/$USER/.ssh/authorized_keys | grep "$x" >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "=> Adding public key to /home/$USER/.ssh/authorized_keys: $x"
            echo "$x" >> /home/$USER/.ssh/authorized_keys
        fi
    done
fi

# if [ ! -f /.root_pw_set ]; then
#   /set_root_pw.sh
# fi

exec /usr/sbin/sshd -D