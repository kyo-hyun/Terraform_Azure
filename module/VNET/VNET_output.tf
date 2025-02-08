output "get_subnet_id" {
    value = {for k,v in azurerm_subnet.example : k => v.id}
}