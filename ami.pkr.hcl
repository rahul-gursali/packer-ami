source "amazon-ebs" "prod" {
region = var.aws_region
instance_type = var.instance_type
source_ami = var.source_ami
ssh_username = var.ssh_username
ami_name = var.ami_name
ssh_key_name = var.ssh_key_name
subnet_id = var.subnet_id
vpc_id = var.vpc_id


# Reuse the same snapshot behavior and ephemeral block device mapping if needed
launch_block_device_mappings = [
{
device_name = "/dev/xvda"
volume_size = 20
volume_type = "gp3"
delete_on_termination = true
}
]


# Timeout increased for slow provisioning
ssh_timeout = "10m"
ami_users = []
}


build {
name = "prod-ami-build"
sources = ["source.amazon-ebs.prod"]


provisioner "shell" {
pause_before = "30s"
script = "./scripts/01-bootstrap.sh"
}


provisioner "shell" {
script = "./scripts/03-install-packages.sh"
}


provisioner "shell" {
script = "./scripts/02-harden.sh"
}


provisioner "shell" {
script = "./scripts/99-cleanup.sh"
}
}
