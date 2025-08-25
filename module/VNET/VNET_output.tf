output "get_subnet_id" {
    value = {for k,v in azurerm_subnet.example : k => v.id}
}

output "get_vnet_id" {
    value = azurerm_virtual_network.example.id
}