resource "azurerm_storage_account" "example" {
  name                              = var.name                             
  resource_group_name               = var.resource_group          
  location                          = var.location                         
  account_tier                      = var.account_tier                     
  account_replication_type          = var.account_replication_type         
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  https_traffic_only_enabled        = var.https_traffic_only_enabled       

  tags = {
    environment = "dev"
  }
}
