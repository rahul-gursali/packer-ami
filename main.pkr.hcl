packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.2.8"
    }
  }
}

# Define the source image (builder)
source "amazon-ebs" "ubuntu" {
  # AMI Naming Convention (Production Best Practice)
  ami_name      = "${var.ami_name_prefix}-${formatdate("YYYY-MM-DD-hhmm", timestamp())}-v${var.ami_version}"
  instance_type = var.instance_type
  region        = var.aws_region

  # Use a source_ami_filter to automatically select the latest official Ubuntu LTS
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-${var.ubuntu_version}-*-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    # Canonical's official AWS Account ID for Ubuntu AMIs
    owners = ["099720109477"] 
  }

  ssh_username = var.ssh_username
  # Production Best Practice: Enforce IMDSv2
  imds_support = "v2.0"
  
  # Add tags for governance and tracking
  tags = {
    Name        = "${var.ami_name_prefix}-base"
    Environment = "Production"
    OS          = "Ubuntu-${var.ubuntu_version}"
    Version     = var.ami_version
  }
}

# Define the build process
build {
  sources = ["source.amazon-ebs.ubuntu"]

  # Provisioner 1: Wait for cloud-init and apply initial updates
  provisioner "shell" {
    inline = [
      "cloud-init status --wait",
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y"
    ]
  }

  # Provisioner 2: Run a separate script for security hardening and core packages
  provisioner "shell" {
    script = "scripts/provisioning.sh"
    # Ensure all scripts are executed as root for system-wide changes
    execute_command = "sudo {{.Path}}" 
  }
  
  # Provisioner 3: Clean up before snapshotting
  provisioner "shell" {
    inline = [
      "sudo cloud-init clean --machine-id", # Remove instance-specific data
      "sudo rm -f /var/log/cloud-init.log /var/log/cloud-init-output.log" # Clean logs
    ]
    execute_command = "sudo {{.Path}}"
  }
}
