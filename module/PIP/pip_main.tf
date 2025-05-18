resource "azurerm_public_ip" "public_ip" {
  name                = var.name
  resource_group_name = var.rg
  location            = var.location
  allocation_method   = "Static"
  zones               = var.zone
  sku                 = var.sku

  tags = var.tags
}