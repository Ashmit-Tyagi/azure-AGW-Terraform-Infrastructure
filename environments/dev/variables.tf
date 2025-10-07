variable "resource_group_name" {
  type        = string
  default     = "dev-rg"
}

variable "location" {
  type        = string
  default     = "East US"
}

variable "public_subnet_address_prefixes" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnet_address_prefixes" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "vm_size" {
  type        = string
  default     = "Standard_B1s"
}

variable "vm_count" {
  type        = number
  default     = 1
}

variable "admin_password" {
  type        = string
  sensitive   = true
}