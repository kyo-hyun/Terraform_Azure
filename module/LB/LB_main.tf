locals {
  nic_pool = flatten([
    for p in var.backend_pool : [
      for vm, nic in p.backend_pool : {
        pool_name = p.backend_pool_name
        nic_id    = nic
        vm        = vm
      }
    ]
  ])

  # NIC인 얘들만
  nic_pool_map = {
    for p in local.nic_pool :
    "${p.pool_name}__${p.vm}" => p
  }
}

resource "azurerm_lb" "lb" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = var.sku

  frontend_ip_configuration {
    name                          = "frontend-${var.name}"
    subnet_id                     = var.public_type == true ? null : var.frontend_ip.subnet
    private_ip_address_allocation = var.public_type == true ? null : "static"
    private_ip_address            = var.public_type == true ? null : var.frontend_ip.private_ip
    public_ip_address_id          = var.public_type == true ? var.frontend_ip.public_ip : null
  }
  
  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  for_each        = {for backend in var.backend_pool : backend.backend_pool_name => backend}
  name            = each.key
  loadbalancer_id = azurerm_lb.lb.id
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_assoc" {
  for_each                = local.nic_pool_map
  network_interface_id    = each.value.nic_id
  ip_configuration_name   = "Ipconfiguration-${each.value.vm}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool[each.value.pool_name].id
}

resource "azurerm_lb_probe" "lb_probe" {
  for_each            = var.health_probe
  name                = each.key
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = each.value.protocol           
  port                = each.value.port               
  request_path        = each.value.request_path       
  interval_in_seconds = each.value.interval_in_seconds
  number_of_probes    = each.value.number_of_probes   
}

resource "azurerm_lb_rule" "lb_rule" {
  for_each                       = var.lb_rule
  name                           = each.key
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = each.value.protocol     
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port 
  frontend_ip_configuration_name = "frontend-${var.name}"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.backend_pool[each.value.backend_pool].id]
  probe_id                       = azurerm_lb_probe.lb_probe[each.value.health_probe].id
}