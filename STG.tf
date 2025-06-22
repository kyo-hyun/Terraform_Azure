locals {
    storage_account_list = {
        "khkimstgtest123" = {
            resource_group                      = "RG-Test"
            location                            = "koreacentral"
            account_tier                        = "Standard"
            account_replication_type            = "LRS"

            infrastructure_encryption_enabled   = true
            https_traffic_only_enabled          = true

            # blob_delete_days                    = 7
            # container_delete_days               = null
            # file_share_delete_days              = 5
        }
    }
}

module "STG" {
    source          = "./module/STG"
    for_each        = local.storage_account_list

    name                                = each.key
    resource_group                      = each.value.resource_group                   
    location                            = each.value.location                         
    account_tier                        = each.value.account_tier                     
    account_replication_type            = each.value.account_replication_type         
    infrastructure_encryption_enabled   = each.value.infrastructure_encryption_enabled
    https_traffic_only_enabled          = each.value.https_traffic_only_enabled       
    # blob_delete_days                    = each.value.blob_delete_days      
    # container_delete_days               = each.value.container_delete_days 
    # file_share_delete_days              = each.value.file_share_delete_days

    depends_on                          = [module.RG]
}