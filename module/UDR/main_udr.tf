# Route Table 생성
resource "azurerm_route_table" "udr" {
  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group
}

# Route 추가
resource "azurerm_route" "route" {
  for_each               = var.route
  name                   = each.key
  resource_group_name    = var.resource_group
  route_table_name       = azurerm_route_table.udr.name
  address_prefix         = each.value.address_prefix        
  next_hop_type          = each.value.next_hop_type         
  next_hop_in_ip_address = try(each.value.next_hop_in_ip_address,null)
}