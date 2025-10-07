output "resource_group_name" {
  value       = azurerm_resource_group.rg.name
}

output "public_subnet_id" {
  value       = azurerm_subnet.public.id
}

output "private_subnet_id" {
  value       = azurerm_subnet.private.id
}

output "nsg_id" {
  value       = azurerm_network_security_group.nsg.id
}

output "location" {
  value       = azurerm_resource_group.rg.location
}