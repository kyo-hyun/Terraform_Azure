resource "azurerm_lb" "example" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = var.sku

  frontend_ip_configuration {
    name                          = "frontend-${var.name}"
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Static"
    private_ip_address            = var.private_ip
  }
}

resource "azurerm_lb_backend_address_pool" "example" {
  name                = "backend-pool"
  loadbalancer_id     = azurerm_lb.example.id
}

resource "azurerm_network_interface_backend_address_pool_association" "example" {
  for_each = var.backend_pool

  network_interface_id    = each.value
  ip_configuration_name   = "Ipconfiguration-${each.key}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.example.id
}

resource "azurerm_lb_probe" "example" {
  name                = "http-probe"
  loadbalancer_id     = azurerm_lb.example.id
  protocol            = "Http"
  port                = 80
  request_path        = "/"
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_rule" "example" {
  name                           = "http-rule"

  loadbalancer_id                = azurerm_lb.example.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "frontend-${var.name}"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.example.id]
  probe_id                       = azurerm_lb_probe.example.id
}