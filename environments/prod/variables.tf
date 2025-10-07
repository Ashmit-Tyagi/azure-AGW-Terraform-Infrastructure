variable "resource_group_name" {
  type        = string
  default     = "prod-rg"
}

variable "location" {
  type        = string
  default     = "West Europe"
}

variable "public_subnet_address_prefixes" {
  type        = list(string)
  default     = ["10.10.1.0/24"]
}

variable "private_subnet_address_prefixes" {
  type        = list(string)
  default     = ["10.10.2.0/24"]
}

variable "vm_size" {
  type        = string
  default     = "Standard_D2s_v3"
}

variable "vm_count" {
  type        = number
  default     = 2
}

variable "admin_password" {
  type        = string
  sensitive   = true
}