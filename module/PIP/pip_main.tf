resource "azurerm_public_ip" "public_ip" {
  name                = var.name
  resource_group_name = var.rg
  location            = var.location
  allocation_method   = "Static"

  tags = var.tags
}