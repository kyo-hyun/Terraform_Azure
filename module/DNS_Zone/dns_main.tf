resource "azurerm_private_dns_zone" "dns_zone" {
  name                = var.name
  resource_group_name = var.rg
}

resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  for_each              = var.vnet_list
  name                  = "${each.key}-link"
  resource_group_name   = var.rg
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone.name
  virtual_network_id    = each.value
}