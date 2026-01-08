output "get_uami_id" {
  value = azurerm_user_assigned_identity.uami.id
}

output "get_uami_principal_id" {
  value = azurerm_user_assigned_identity.uami.principal_id
}