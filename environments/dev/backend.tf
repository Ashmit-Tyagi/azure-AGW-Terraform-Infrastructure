terraform {
  backend "azurerm" {
    resource_group_name  = "dev-rg"
    storage_account_name = "devopskawork7"
    container_name       = "spooky-dev"
    key                  = "vnet-compute/dev.terraform.tfstate"
    use_azuread_auth     = true
  }
}
