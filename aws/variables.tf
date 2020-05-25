variable "access_key" {
	default = "access"
}
variable "secret_key" {
	default = "secret"
}
variable "region" {
  default = "ap-southeast-1"
}
variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default = "10.1.0.0/16"
}
variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default = "10.1.0.0/24"
}
variable "availability_zone" {
  description = "availability zone to create subnet"
  default = "ap-southeast-1a"
}
variable "public_key_path" {
  description = "Public key path"
  default = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Private key path"
  default = "~/.ssh/id_rsa"
}

variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  default = "ami-560c0935"
}
variable "instance_type" {
  description = "type for aws EC2 instance"
  default = "t3.micro"
}
variable "environment_tag" {
  description = "Environment tag"
  default = "Staging"
}