#!/usr/bin/env bash
set -euo pipefail


logger "packer: installing packages"


# Idempotent package installation wrapper
install_pkgs_yum() {
yum install -y "$@"
}


install_pkgs_apt() {
DEBIAN_FRONTEND=noninteractive apt-get install -y "$@"
}


if command -v yum >/dev/null 2>&1; then
install_pkgs_yum nginx git awscli jq
elif command -v apt-get >/dev/null 2>&1; then
install_pkgs_apt nginx git awscli jq
fi


# Enable and start lightweight services that should be present
if systemctl is-enabled nginx >/dev/null 2>&1; then
systemctl disable nginx || true
fi


logger "packer: package install complete"
