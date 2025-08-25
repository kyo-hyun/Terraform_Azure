# Hub → Spoke Peering
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "hub-to-spoke"
  resource_group_name       = "RG-KHKIM"
  virtual_network_name      = "vnet-hub"
  remote_virtual_network_id = module.vnet["vnet-spoke"].get_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

# Spoke → Hub Peering
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "spoke-to-hub"
  resource_group_name       = "RG-KHKIM"
  virtual_network_name      = "vnet-spoke"
  remote_virtual_network_id = module.vnet["vnet-hub"].get_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}