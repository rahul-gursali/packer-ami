variable "aws_region" {
  type    = string
  default = "us-east-1"
  description = "AWS region to build the AMI in."
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
  description = "Temporary EC2 instance type for the build."
}

variable "ami_name_prefix" {
  type    = string
  default = "prod-ubuntu-base"
  description = "Prefix for the final AMI name."
}

variable "ubuntu_version" {
  type    = string
  default = "jammy-22.04"
  description = "Ubuntu LTS version (e.g., jammy-22.04)."
}

variable "ami_version" {
  type    = string
  default = "1.0"
  description = "Semantic version for the custom configuration layer."
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
  description = "The default SSH user for the base AMI."
}
