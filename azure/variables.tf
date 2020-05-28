variable "region" {
  default = "useast"
}

variable "resource_group_name" {
  default = "TERRAFORM-RG03"
}

variable "subscription_id" {
  default = "00000000-0000-0000-0000-000000000000"
}

variable "client_id" {
  default = "00000000-0000-0000-0000-000000000000"
}

variable "tenant_id" {
  default = "00000000-0000-0000-0000-000000000000"
}

variable "public_key_path" {
  description = "Public key path"
  default = "~/.ssh/id_rsa.pub"
}

variable "vpc" {
  description = "Azure Network"
  default = "10.0.0.0/16"
}

variable "subnet" {
  description = "Azure Subnet"
  default = "10.0.2.0/24"
}

variable "vm_size" {
  description = "Azure VM Size"
  default = "Standard_DS1_v2"
}

variable "storage_disk_type" {
  description = "Managed disk type"
  default = "Standard_F2"
}
variable "environment_tag" {
  description = "Environment tag"
  default = "Staging"
}