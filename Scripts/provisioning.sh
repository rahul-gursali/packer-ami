#!/bin/bash
set -eux # Exit immediately if a command exits with a non-zero status

echo "==> Installing Core Packages"
# Install essential packages for a production environment
sudo apt-get install -y \
    curl \
    wget \
    git \
    vim \
    jq \
    net-tools \
    apt-transport-https \
    ca-certificates

echo "==> Applying Security Hardening"
# Install and enable Uncomplicated Firewall (UFW)
sudo apt-get install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh # Allow SSH access
sudo ufw --force enable

# Install fail2ban for SSH brute-force protection
sudo apt-get install -y fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Disable root login over SSH (if not already disabled by default AMI)
# Note: For production, this is a strong requirement.
if grep -q "PermitRootLogin yes" /etc/ssh/sshd_config; then
    sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
    sudo systemctl restart sshd
fi

echo "==> Installing Monitoring/Logging Agents (Example: AWS CloudWatch Agent)"
# This would involve installing and configuring your specific agents (e.g., CloudWatch, Datadog, Splunk)

echo "==> Completed AMI Provisioning"

# final commands:

packer init .
packer validate main.pkr.hcl
packer build main.pkr.hcl
