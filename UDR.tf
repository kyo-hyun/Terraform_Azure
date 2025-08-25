# locals {
#   udr_list = {
#     "udr-agw" = {
#       resource_group = "RG-KHKIM"
#       location       = "koreacentral"

#       subnets = {
#         "vnet-khkim-hub" = "agw-subnet"
#       }

#       route = {
#         "udr-agw-to-lb-via-fw" = {
#           address_prefix          = "12.0.3.0/24"
#           next_hop_type           = "VirtualAppliance"
#           next_hop_in_ip_address  = "10.0.0.4"
#         }
#       }
#     }

#     "udr-aks" = {
#       resource_group = "RG-KHKIM"
#       location       = "koreacentral"
      
#       subnets = {
#         "vnet-khkim-spoke" = "aks-cluster-subnet"
#       }

#       route = {
#         "udr-aks-to-fw" = {
#           address_prefix          = "0.0.0.0/0"
#           next_hop_type           = "VirtualAppliance"
#           next_hop_in_ip_address  = "10.0.0.4"
#         }
#       }
#     }
#   }
# }

# module "udr" {
#   source    = "./module/UDR"
#   for_each  = local.udr_list
  
#   name           = each.key
#   resource_group = each.value.resource_group
#   location       = each.value.location
#   route          = each.value.route
#   subnets = {
#     for vnet_name, subnet_name in each.value.subnets : 
#       vnet_name => module.vnet[vnet_name].get_subnet_id[subnet_name]
#   }

#   depends_on = [module.RG]
# }