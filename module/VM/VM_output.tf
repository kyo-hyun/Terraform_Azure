output "nic_ids" {
  value = {
    primary   = azurerm_network_interface.primary_nic.id
    secondary = var.secondary_nic != null ? azurerm_network_interface.secondary_nic[0].id : null
  }
}

output "get_nic_id" {
  value = azurerm_network_interface.primary_nic.id
}