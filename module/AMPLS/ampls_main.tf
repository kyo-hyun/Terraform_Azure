resource "azurerm_monitor_private_link_scope" "ampls" {
  name                = var.name
  resource_group_name = var.rg
}

resource "azurerm_monitor_private_link_scoped_service" "law" {
  name                = "law-connection"
  resource_group_name = var.rg
  scope_name          = azurerm_monitor_private_link_scope.ampls.name

  linked_resource_id  = var.law
}

resource "azurerm_monitor_private_link_scoped_service" "dce" {
  name                = "dce-connection"
  resource_group_name = var.rg
  scope_name          = azurerm_monitor_private_link_scope.ampls.name

  linked_resource_id  = var.dce_id
}

resource "azurerm_private_endpoint" "ampls_pe" {
  name                = "${var.name}-pep"
  location            = var.location
  resource_group_name = var.rg
  subnet_id           = var.snet_id

  private_service_connection {
    name                           = "ampls-psc"
    private_connection_resource_id = azurerm_monitor_private_link_scope.ampls.id
    subresource_names              = ["azuremonitor"]
    is_manual_connection           = false
  }
}

# resource "azurerm_private_dns_zone" "monitor" {
#   name                = "privatelink.monitor.azure.com"
#   resource_group_name = var.rg_name
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "monitor_link" {
#   name                  = "monitor-vnet-link"
#   resource_group_name   = var.rg_name
#   private_dns_zone_name = azurerm_private_dns_zone.monitor.name
#   virtual_network_id    = var.vnet_id

#   registration_enabled  = false
# }

# resource "azurerm_private_dns_zone_group" "ampls_dns" {
#   name                 = "ampls-dns-group"
#   private_endpoint_id  = azurerm_private_endpoint.ampls_pe.id

#   private_dns_zone_configs {
#     name                = "monitor-zone"
#     private_dns_zone_id = azurerm_private_dns_zone.monitor.id
#   }
# }