#!/bin/bash
#set -xv
USER_=$1
TMP_CERT=$2
cat $TMP_CERT
PORT=$3
PHASED_LAYER_CHROOT=/phased_layer_tunnel
USER_DIR=$PHASED_LAYER_CHROOT/home/$USER_
USER_CERT=$USER_DIR/.ssh/authorized_keys
echo "USER: $USER_ TMP_CERT: $TMP_CERT"
#if [ !-d /home/$USER_/.ssh ] ; then
mkdir -p $USER_DIR/.ssh
#echo "no-port-forwarding,no-agent-forwarding,permitopen='127.0.0.1:$PORT'" > $USER_CERT
cat $TMP_CERT >> $USER_CERT
