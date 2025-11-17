variable "aws_region" {
type = string
default = "ap-south-1"
}


variable "instance_type" {
type = string
default = "t3.small"
}


variable "source_ami" {
type = string
# Use latest official Amazon Linux 2 or Ubuntu LTS AMI ID per region (set in CI or override locally)
default = "ami-0c1a7f89451184c8b"
}


variable "ssh_username" {
type = string
default = "ec2-user"
}


variable "ami_name" {
type = string
default = "prod-ami-{{timestamp}}"
}


variable "ssh_key_name" {
type = string
default = "packer-key"
}


variable "subnet_id" {
type = string
default = ""
}


variable "vpc_id" {
type = string
default = ""
}
