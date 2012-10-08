#!/bin/bash
#set -xv
USER_=$1
USER_DIR=/home/$USER_
USER_CERT=$USER_DIR/.ssh/authorized_keys
d_=/phased_layer_tunnel
chroot $d_ chown -R $USER_ $USER_DIR
chroot $d_ chown -R $USER_ $USER_DIR/.ssh
chroot $d_ chmod 750 $USER_DIR/.ssh
chroot $d_ chmod 640 $USER_CERT

