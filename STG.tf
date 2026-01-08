locals {
    storage_account_list = {
        "spoke1prodstg" = {
            resource_group                      = "Spoke1_rg"
            location                            = "koreacentral"
            account_tier                        = "Standard"
            account_replication_type            = "LRS"
            file_shares = {
              "share1" = { quota = 50 }
            }

            file_share_dns_zone                 = "privatelink.file.core.windows.net"

            vnet_name      = "spoke1-vnet"
            pe_subnet_name = "pep-snet"
            infrastructure_encryption_enabled   = true
            https_traffic_only_enabled          = true
        }
        
        "spoke2prodstg" = {
            resource_group                      = "Spoke2_rg"
            location                            = "koreacentral"
            account_tier                        = "Standard"
            account_replication_type            = "LRS"

            file_shares = {
              "share1" = { quota = 50 }
            }

            file_share_dns_zone                 = "privatelink.file.core.windows.net"

            vnet_name                           = "spoke2-vnet"
            pe_subnet_name                      = "pep-snet"

            infrastructure_encryption_enabled   = true
            https_traffic_only_enabled          = true
        }
    }
}

module "STG" {
    source          = "./module/STG"
    for_each        = local.storage_account_list

    name                              = each.key
    resource_group                    = each.value.resource_group                   
    location                          = each.value.location                         
    account_tier                      = each.value.account_tier                     
    account_replication_type          = each.value.account_replication_type         
    infrastructure_encryption_enabled = each.value.infrastructure_encryption_enabled
    https_traffic_only_enabled        = each.value.https_traffic_only_enabled       
    file_shares                       = each.value.file_shares
    pe_subnet_id                      = module.vnet[each.value.vnet_name].get_subnet_id[each.value.pe_subnet_name]
    file_share_dns_zone               = module.DNS_Zone[each.value.file_share_dns_zone].get_dns_zone_id
    depends_on                        = [module.RG]
}