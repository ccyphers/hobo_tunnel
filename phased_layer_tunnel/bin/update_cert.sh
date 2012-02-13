#!/bin/bash
#set -xv
USER_=$1
TMP_CERT=$2
cat $TMP_CERT
PORT=$3
USER_CERT=/home/$USER_/.ssh/authorized_keys
echo "USER: $USER_ TMP_CERT: $TMP_CERT"
#if [ !-d /home/$USER_/.ssh ] ; then
mkdir -p /home/$USER_/.ssh
chown -R $USER_ /home/$USER_
chown -R $USER_ /home/$USER_/.ssh
chmod 700 /home/$USER_/.ssh
#fi

#echo "no-port-forwarding,no-agent-forwarding,permitopen='127.0.0.1:$PORT'" > $USER_CERT
cat $TMP_CERT >> $USER_CERT
chown $USER_ $USER_CERT
chmod 640 $USER_CERT
