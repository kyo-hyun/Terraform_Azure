output "get_pip_id" {
    value = azurerm_public_ip.public_ip.id
}

output "get_pip_address" {
    value = azurerm_public_ip.public_ip.ip_address
}