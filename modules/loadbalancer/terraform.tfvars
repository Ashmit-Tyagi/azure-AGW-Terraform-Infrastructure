environment               = "dev"
location                  = "East US "
resource_group_name       = "rg-dev-appgw"
public_subnet_id          = "/subscriptions/sub-id/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/appgw-subnet"
backend_ip_addresses      = ["10.0.2.4", "10.0.2.5"]

public_ip_allocation_method = "Static"
public_ip_sku               = "Standard"

app_gateway_sku_name        = "Standard_v2"
app_gateway_sku_tier        = "Standard_v2"
app_gateway_capacity        = 2

frontend_port_http_name     = "http-80"
frontend_port_http_port     = 80

backend_pool_name           = "web-servers-pool"

http_settings_name          = "http-settings-80"
cookie_based_affinity       = "Disabled"
backend_http_port           = 8080
backend_http_protocol       = "Http"
request_timeout             = 90
backend_host_name           = "127.0.0.1"

http_listener_name          = "inbound-http-listener"
http_listener_protocol      = "Http"

routing_rule_name           = "path-basic-rule"
routing_rule_type           = "Basic"
routing_rule_priority       = 100

probe_name                  = "web-health-probe"
probe_protocol              = "Http"
probe_host                  = "127.0.0.1"
probe_path                  = "/health"
probe_interval              = 45
probe_timeout               = 45
probe_unhealthy_threshold   = 3
