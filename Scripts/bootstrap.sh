#!/usr/bin/env bash
set -euo pipefail


# Basic bootstrap: update, create packer user (if needed), add logs
logger "packer: bootstrap start"


# Update package cache
if command -v yum >/dev/null 2>&1; then
yum -y update
elif command -v apt-get >/dev/null 2>&1; then
DEBIAN_FRONTEND=noninteractive apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
fi


# create a non-root admin user
if ! id -u packer-user >/dev/null 2>&1; then
useradd -m -s /bin/bash packer-user
echo "packer-user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/packer-user
chmod 440 /etc/sudoers.d/packer-user
fi


logger "packer: bootstrap complete"
