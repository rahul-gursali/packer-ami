#!/usr/bin/env bash
set -euo pipefail


logger "packer: cleanup start"


# Remove SSH host keys so instances generate new ones at first boot
rm -f /etc/ssh/ssh_host_* || true


# Clear shell history
history -c || true
rm -f /root/.bash_history || true
rm -f /home/packer-user/.bash_history || true


# Clean package caches
if command -v yum >/dev/null 2>&1; then
yum clean all
elif command -v apt-get >/dev/null 2>&1; then
apt-get clean
rm -rf /var/lib/apt/lists/*
fi


# Zero out free space to minimise snapshot size 
# dd if=/dev/zero of=/EMPTY bs=1M || true
# rm -f /EMPTY || true


logger "packer: cleanup complete"
