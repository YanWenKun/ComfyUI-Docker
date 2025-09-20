#!/bin/bash

# When you have to run as root inside container (e.g. rootless Podman)

set -e

ln -sf  /root/.*  /home/runner
ln -sf  /root/*  /home/runner

cd /root

if [ ! -f "/root/bin/python3.11" ] ; then
    python3 -m venv --system-site-packages .
fi ;
source /root/bin/activate

chmod +x /home/scripts/entrypoint.sh
source /home/scripts/entrypoint.sh
