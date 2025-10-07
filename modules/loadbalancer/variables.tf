variable "environment" {
  type        = string
}

variable "location" {
  type        = string
}

variable "resource_group_name" {
  type        = string
}

variable "public_subnet_id" {
  type        = string
}

variable "backend_ip_addresses" {
  type        = list(string)
}