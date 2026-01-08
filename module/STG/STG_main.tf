# Storage Account 생성 (기존)
resource "azurerm_storage_account" "stg" {
  name                              = var.name
  resource_group_name               = var.resource_group
  location                          = var.location
  account_tier                      = var.account_tier
  account_replication_type          = var.account_replication_type
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  https_traffic_only_enabled        = var.https_traffic_only_enabled
}

# File Share 생성
resource "azurerm_storage_share" "share" {
  for_each           = var.file_shares
  name               = each.key
  storage_account_id = azurerm_storage_account.stg.id
  quota              = each.value.quota
}

# Private Endpoint 생성
resource "azurerm_private_endpoint" "pe" {
  name                = "pe-${var.name}-file"
  location            = var.location
  resource_group_name = var.resource_group
  subnet_id           = var.pe_subnet_id

  private_service_connection {
    name                           = "psc-${var.name}-file"
    private_connection_resource_id = azurerm_storage_account.stg.id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }

  private_dns_zone_group {
    name                 = "dns-group"
    private_dns_zone_ids = [var.file_share_dns_zone]
  }
}