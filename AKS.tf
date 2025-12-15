locals {
    aks_list = {
        "khkim-ak2" = {
            kube_version                    = "1.34"

            resource_group                  = "khkim_rg"
            location                        = "koreacentral"
            vnet                            = "Hub-vnet"
            subnet                          = "aks-node-subnet"
            outbound_type                   = "loadBalancer"
            private_cluster_enabled         = false
            #private_dns_zone_id             = ""
            managed_id                      = ""

            # k8s network
            network_plugin                  = "azure" 
            network_plugin_mode             = "overlay"
            network_policy                  = "azure"
            service_cidr                    = "172.20.4.0/22"
            dns_service_ip                  = "172.20.4.10"
            dns_prefix                      = "khkim-aks"
            automatic_channel_upgrade       = "SecurityPatch"
            maintenance_auto_upgrade = {
                day_of_month = 0
                day_of_week  = "Sunday"
                duration     = 8
                frequency    = "Weekly"
                interval     = 1
                start_date   = "2025-11-20T00:00:00Z"
                start_time   = "00:00"
                utc_offset   = "+00:00"
            }

            # system nodepool
            system_node_pool = {
                node_count                  = 1
                node_pool_name              = "systempool1"
                vm_size                     = "Standard_D2ds_v5"
                os_disk_size_gb             = 128
                os_disk_type                = "Managed"
                auto_scaling_enabled        = false
                min_count                   = 1
                max_count                   = 3
                node_taints                 = ["CriticalAddonsOnly=true:NoSchedule"]
                node_labels = {
                    "node.kubernetes.io/role" : "system"
                }
            }

            user_node_pool = {
                # "nodepool1" = {
                #     node_count              = 1
                #     vm_size                 = "Standard_D4ds_v5"
                #     mode                    = "User"
                #     os_type                 = "Linux"
                #     os_disk_size_gb         = 128
                #     os_disk_type            = "Managed"
                #     #auto_scaling_enabled    = true
                #     #min_count               = 2
                #     #max_count               = 1
                #     #node_taints             = [""]
                #     node_labels = {
                #         "node.kubernetes.io/role" : "app"
                #     }
                # }
            }
        }
    }
}

module "aks" {
    source                    = "./module/AKS"
    for_each                  = local.aks_list

    name                      = each.key
    kube_version              = each.value.kube_version
    resource_group            = each.value.resource_group
    location                  = each.value.location
    subnet                    = module.vnet[each.value.vnet].get_subnet_id[each.value.subnet]
    network_plugin            = each.value.network_plugin
    network_plugin_mode       = each.value.network_plugin_mode
    network_policy            = each.value.network_policy
    dns_prefix                = each.value.dns_prefix
    private_dns_zone_id       = try(each.value.private_dns_zone_id,null)
    managed_id                = try(each.value.user_assigned_identity_ids,null)
    service_cidr              = each.value.service_cidr       
    dns_service_ip            = each.value.dns_service_ip
    maintenance_auto_upgrade  = each.value.maintenance_auto_upgrade
    system_node_pool          = each.value.system_node_pool
    user_node_pool            = each.value.user_node_pool
    outbound_type             = each.value.outbound_type
    private_cluster_enabled   = each.value.private_cluster_enabled
    automatic_channel_upgrade = each.value.automatic_channel_upgrade
    tenant_id                 = local.spn.AzureSPN.CNT_Plus_Tenant.tenant_id

    depends_on                = [module.RG]
}