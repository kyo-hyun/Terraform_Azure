# locals {
#     aks_list = {
#         "AKS-Test" = {
#             kube_version                    = "1.31.8"

#             resource_group                  = "RG-KHKIM"
#             location                        = "koreacentral"
#             vnet                            = "vnet-khkim-spoke"
#             subnet                          = "aks-cluster-subnet"
#             outbound_type                   = "loadBalancer"
#             private_cluster_enabled         = false

#             # k8s network
#             network_plugin                  = "azure"
#             network_plugin_mode             = "overlay"
#             network_policy                  = "azure"
#             service_cidr                    = "11.0.0.0/16"
#             dns_service_ip                  = "11.0.0.10"

#             # system nodepool
#             system_node_pool = {
#                 "systempool" = {
#                     node_count              = 1
#                     vm_size                 = "Standard_F2s_v2"
#                 }
#             }

#             user_node_pool = {
#                 "nodepool" = {
#                     node_count              = 1
#                     vm_size                 = "Standard_F2s_v2"
#                     mode                    = "User"
#                     os_type                 = "Linux"
#                     os_disk_size_gb         = 30
#                     auto_scaling_enabled    = true
#                     min_count               = 1
#                     max_count               = 1
#                 }
#             }
#         }
#     }
# }

# module "aks" {
#     source                  = "./module/AKS"
#     for_each                = local.aks_list

#     name                    = each.key
#     kube_version            = each.value.kube_version
#     resource_group          = each.value.resource_group
#     location                = each.value.location
#     subnet                  = module.vnet[each.value.vnet].get_subnet_id[each.value.subnet]
#     network_plugin          = each.value.network_plugin     
#     network_plugin_mode     = each.value.network_plugin_mode
#     network_policy          = each.value.network_policy     
#     service_cidr            = each.value.service_cidr       
#     dns_service_ip          = each.value.dns_service_ip     
#     system_node_pool        = each.value.system_node_pool
#     user_node_pool          = each.value.user_node_pool
#     outbound_type           = each.value.outbound_type
#     private_cluster_enabled = each.value.private_cluster_enabled

#     depends_on              = [module.RG]
# }