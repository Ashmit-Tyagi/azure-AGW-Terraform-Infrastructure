terraform {
  backend "azurerm" {
    resource_group_name  = "dev-rg"
    storage_account_name = ""
    container_name       = ""
    key                  = "vnet-compute/dev.terraform.tfstate"
    use_azuread_auth     = true
  }
}
