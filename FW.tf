locals {
    fw_list = {
        "FW-khkim-standard" = {
            resource_group = "RG-KHKIM"
            location       = "koreacentral"
            vnet           = "vnet-khkim-hub"
            public_ip      = "PIP-fw-pip"
            subnet         = "AzureFirewallSubnet"
            sku            = "Standard"
            mgmt_pip       = "PIP-fw-mgmt-pip"
            mgmt_subnet    = "AzureFirewallManagementSubnet"

            network_collection = {
                "network-collection" = {
                    priority = 100
                    action   = "Allow"

                    rule = {
                        "Allow-agw-to-ingress" = {
                            protocols             = ["TCP"]
                            source_addresses      = ["10.0.0.160/29"]
                            destination_addresses = ["12.0.3.0/24"]
                            destination_ports     = ["80"]
                        }

                        "Allow-aks-to-all" = { 
                            protocols             = ["TCP","UDP"]
                            source_addresses      = ["10.0.2.0/24"]
                            destination_addresses = ["0.0.0.0/0"]
                            destination_ports     = ["*"]
                        }
                    }
                }
            }
        }
    }
}

# module "fw" {
#     source             = "./module/FW"
#     for_each           = local.fw_list
    
#     name               = each.key
#     resource_group     = each.value.resource_group
#     location           = each.value.location             
#     public_ip          = module.pip[each.value.public_ip].get_pip_id     
#     subnet             = module.vnet[each.value.vnet].get_subnet_id[each.value.subnet]
#     sku                = each.value.sku           
#     mgmt_pip           = module.pip[each.value.mgmt_pip].get_pip_id   
#     mgmt_subnet        = module.vnet[each.value.vnet].get_subnet_id[each.value.mgmt_subnet]
#     network_collection = each.value.network_collection

#     depends_on     = [module.RG]
# }