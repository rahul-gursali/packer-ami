#!/usr/bin/env bash
set -euo pipefail


logger "packer: hardening start"


# 1) remove SSH password auth and root login
if [ -f /etc/ssh/sshd_config ]; then
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
fi


# 2) restrict ulimit and cron permissions (example)
# 3) ensure sudoers secure
chmod 440 /etc/sudoers.d/packer-user || true


# 4) minimal sysctl hardening (example values)
cat >/etc/sysctl.d/60-security.conf <<EOF
net.ipv4.ip_forward = 0
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1
EOF
sysctl --system


# 5) rotate logs and remove world-writable files
chmod -R go-w /etc/ssh || true


logger "packer: hardening complete"
