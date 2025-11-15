# vnet 생성
resource "azurerm_virtual_network" "vnet" {
  name                   = var.name
  location               = var.location
  resource_group_name    = var.resource_group
  address_space          = var.address_space
  tags                   = var.tags
}

# subnet 생성
resource "azurerm_subnet" "subnet" {
    for_each             = {for subnet in var.subnets : subnet.subnet_name => subnet}
    name                 = each.key
    resource_group_name  = var.resource_group
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = each.value.address_prefixes

    dynamic "delegation" {
      for_each = lookup(each.value, "service_delegation", null) != null ? [1] : []
      content {
        name = "${each.key}-delegration"
        
        service_delegation {
          name = each.value.service_delegation
          actions = [
            "Microsoft.Network/virtualNetworks/subnets/join/action",
          ]
        }
      }
    }
}

# NSG 할당
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  for_each                  = {for subnet in var.subnets : subnet.subnet_name => subnet if subnet.nsg != null}
  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = each.value.nsg_id
}

# UDR 할당
resource "azurerm_subnet_route_table_association" "udr_assoc" {
  for_each       = {for subnet in var.subnets : subnet.subnet_name => subnet if subnet.udr != null}
  subnet_id      = azurerm_subnet.subnet[each.key].id
  route_table_id = each.value.udr_id
}