terraform {
  backend "azurerm" {
    resource_group_name  = "devops-rg"
    storage_account_name = "zoopzoop"
    container_name       = "meowgng"
    key                  = "vnet-compute/dev.terraform.tfstate"
    use_azuread_auth     = true
  }
}
