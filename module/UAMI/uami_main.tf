locals {
  role_map = {
    for idx, val in var.assignments : "${var.name}_${idx}" => val
  }
}

resource "azurerm_user_assigned_identity" "uami" {
  name                = var.name
  resource_group_name = var.resource_group
  location            = var.location
}

resource "azurerm_role_assignment" "ra" {
  for_each             = local.role_map
  scope                = each.value.scope
  role_definition_name = each.value.role_name
  principal_id         = azurerm_user_assigned_identity.uami.principal_id
}