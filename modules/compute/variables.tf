variable "environment" {
  type        = string
}

variable "location" {
  type        = string
}

variable "resource_group_name" {
  type        = string
}

variable "private_subnet_id" {
  type        = string
}

variable "nsg_id" {
  type        = string
}

variable "vm_size" {
  type        = string
}

variable "admin_password" {
  type        = string
}

variable "vm_count" {
  type        = number
}

variable "user_data_script" {
  type        = string
}