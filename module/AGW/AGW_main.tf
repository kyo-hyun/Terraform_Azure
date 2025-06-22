resource "azurerm_application_gateway" "network" {
  name                = var.name
  resource_group_name = var.rg
  location            = var.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.subnet
  }

  frontend_port {
    name = "frontend_port_name"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontend_ip_configuration_name"
    public_ip_address_id = var.public_ip
  }

  backend_address_pool {
    name = "backend_address_pool_name"
  }

  backend_http_settings {
    name                  = "backend_set"
    cookie_based_affinity = "Disabled"
    #path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "http_listener"
    frontend_ip_configuration_name = "frontend_ip_configuration_name"
    frontend_port_name             = "frontend_port_name"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "routing_rule"
    priority                   = 9
    rule_type                  = "Basic"
    http_listener_name         = "http_listener"
    backend_address_pool_name  = "backend_address_pool_name"
    backend_http_settings_name = "backend_set"
  }
}