#!/bin/bash

UPDATE_ON_START=${UPDATE_ON_START:=yes}
if [ "$UPDATE_ON_START" = "yes" ]; then
    echo "Updating before running"
    apt-get update -y && apt-get upgrade -y
fi

echo "Ensuring ~root/.ssh/ exists"
mkdir -p ~root/.ssh
chmod -R 0600 ~root/.ssh
ROOT_SSH_KEY=${ROOT_SSH_KEY:=""}
if [ ! -z "$ROOT_SSH_KEY" ]; then
    echo -e "Setting root authorized_keys to:\n$ROOT_SSH_KEY"
    echo "$ROOT_SSH_KEY" >~root/.ssh/authorized_keys
fi

echo "Running $*"
eval $*