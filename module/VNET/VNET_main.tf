# vnet 생성
resource "azurerm_virtual_network" "example" {
  name                   = var.name
  location               = var.location
  resource_group_name    = var.resource_group
  address_space          = var.address_space
  tags                   = var.tags
}

# subnet 생성
resource "azurerm_subnet" "example" {
    for_each             = var.subnets
    name                 = each.key
    resource_group_name  = var.resource_group
    virtual_network_name = azurerm_virtual_network.example.name
    address_prefixes     = each.value.address_prefixes
}