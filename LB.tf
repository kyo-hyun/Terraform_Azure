# locals {
#     lb_list = {
#         "lb-internal" = {            
#             resource_group   = "RG-KHKIM"
#             location         = "koreacentral"
#             vnet             = "vnet-khkim-hub"
#             subnet           = "lb-subnet"
#             private_ip       = "10.0.0.69"
#             sku              = "Standard"

#             backend_pool = {
#                 backend1     = "web1-vm"
#                 #backend2     = "khkim-back2"
#             }
#         }
#     }
# }

# module "LB" {
#     source          = "./module/LB"
#     for_each        = local.lb_list
    
#     name            = each.key
#     resource_group  = each.value.resource_group
#     location        = each.value.location
#     subnet          = module.vnet[each.value.vnet].get_subnet_id[each.value.subnet]
#     private_ip      = each.value.private_ip
#     sku             = each.value.sku

#     backend_pool    = { for backend in each.value.backend_pool : backend => module.azure_vm[backend].get_nic_id }
# }