output "app_gateway_public_ip" {
  value       = azurerm_public_ip.app_gateway_ip.ip_address
}