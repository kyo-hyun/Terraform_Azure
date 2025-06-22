locals {
    AGW_List = {
        "AGW-khkim" = {
            rg                  = "RG-Test"
            location            = "koreacentral"
            vnet                = "vnet-khkim-hub"
            subnet              = "agw-snet"
            public_ip           = "PIP-AGW"
        }
    }
}

# module "AGW" {
#     source      = "./module/AGW"
#     for_each    = local.AGW_List
    
#     name        = each.key
#     rg          = each.value.rg
#     location    = each.value.location
#     subnet      = module.vnet[each.value.vnet].get_subnet_id[each.value.subnet]
#     public_ip   = module.pip[each.value.public_ip].get_pip_id
# }