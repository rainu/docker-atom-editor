#!/bin/bash

USER="atom"


#set uid/gui to hosts user spec
usermod -u $HOST_USER_UID $USER
groupadd -fg $HOST_USER_GID $USER"_GROUP"
usermod -g $HOST_USER_GID $USER

SCRIPT=$(mktemp)
echo "cd $PWD; /usr/bin/atom $@" > $SCRIPT
chmod 777 $SCRIPT

su atom -c "$SCRIPT"

rm $SCRIPT
