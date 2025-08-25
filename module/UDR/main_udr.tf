# Route Table 생성
resource "azurerm_route_table" "example" {
  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group
}

# Route 추가
resource "azurerm_route" "example" {
  for_each               = var.route
  name                   = each.key
  resource_group_name    = var.resource_group
  route_table_name       = azurerm_route_table.example.name
  address_prefix         = each.value.address_prefix        
  next_hop_type          = each.value.next_hop_type         
  next_hop_in_ip_address = each.value.next_hop_in_ip_address
}

# 서브넷에 Route Table 연결
resource "azurerm_subnet_route_table_association" "example" {
  for_each       = var.subnets
  subnet_id      = each.value
  route_table_id = azurerm_route_table.example.id
}