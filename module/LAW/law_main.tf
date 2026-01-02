resource "azurerm_log_analytics_workspace" "law" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg
  sku                 = var.sku
  retention_in_days   = var.retention_in_days
}