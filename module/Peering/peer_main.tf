resource "azurerm_virtual_network_peering" "local_to_remote" {
  name                          = "peer-${var.local_vnet}-to-${var.remote_vnet}"
  resource_group_name           = var.local_vnet_rg
  virtual_network_name          = var.local_vnet
  remote_virtual_network_id     = var.remote_vnet_id

  allow_virtual_network_access  = true
  allow_forwarded_traffic       = true
  allow_gateway_transit         = false
  use_remote_gateways           = false
}

resource "azurerm_virtual_network_peering" "remote_to_local" {
  name                         = "peer-${var.remote_vnet}-to-${var.local_vnet}"
  resource_group_name          = var.remote_vnet_rg
  virtual_network_name         = var.remote_vnet
  remote_virtual_network_id    = var.local_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  use_remote_gateways          = false
}