output "app_gateway_ip" {
  value       = module.loadbalancer.app_gateway_public_ip
}