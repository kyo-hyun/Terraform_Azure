locals {
    aks_list = {
        "spoke1-aks" = {
            kube_version                    = "1.34"

            resource_group                  = "Spoke1_rg"
            location                        = "koreacentral"
            vnet                            = "spoke1-vnet"
            subnet                          = "aks-snet"
            outbound_type                   = "userDefinedRouting"
            private_cluster_enabled         = true
            private_dns_zone_id             = "privatelink.koreacentral.azmk8s.io"
            user_assigned_identity_id       = "spoke1-uami"

            # k8s network
            network_plugin                  = "azure" 
            network_plugin_mode             = "overlay"
            network_policy                  = "azure"
            service_cidr                    = "172.20.4.0/22"
            dns_service_ip                  = "172.20.4.10"
            dns_prefix                      = "khkim-aks"
            automatic_channel_upgrade       = "None"

            rbac                            = "azrbac"

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
                "nodepool1" = {
                    vm_size                 = "Standard_D2ds_v5"
                    mode                    = "User"
                    os_type                 = "Linux"
                    os_disk_size_gb         = 128
                    os_disk_type            = "Managed"
                    auto_scaling_enabled    = true
                    min_count               = 2
                    max_count               = 1
                    node_labels = {
                        "node.kubernetes.io/role" : "app"
                    }
                }
            }
        }

        "spoke2-aks" = {
            kube_version                    = "1.34"

            resource_group                  = "Spoke1_rg"
            location                        = "koreacentral"
            vnet                            = "spoke2-vnet"
            subnet                          = "aks-snet"
            outbound_type                   = "userDefinedRouting"
            private_cluster_enabled         = true
            private_dns_zone_id             = "privatelink.koreacentral.azmk8s.io"
            user_assigned_identity_id       = "spoke2-uami"

            # k8s network
            network_plugin                  = "azure" 
            network_plugin_mode             = "overlay"
            network_policy                  = "azure"
            service_cidr                    = "172.20.4.0/22"
            dns_service_ip                  = "172.20.4.10"
            dns_prefix                      = "khkim-aks"
            automatic_channel_upgrade       = "None"

            rbac                            = "azrbac"

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
                "nodepool1" = {
                    vm_size                 = "Standard_D2ds_v5"
                    mode                    = "User"
                    os_type                 = "Linux"
                    os_disk_size_gb         = 128
                    os_disk_type            = "Managed"
                    auto_scaling_enabled    = true
                    min_count               = 2
                    max_count               = 1
                    node_labels = {
                        "node.kubernetes.io/role" : "app"
                    }
                }
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
    private_dns_zone_id       = try(each.value.private_dns_zone_id,null) != null ? module.DNS_Zone[each.value.private_dns_zone_id].get_dns_zone_id : null
    managed_id                = try(each.value.user_assigned_identity_ids,null)
    service_cidr              = each.value.service_cidr       
    dns_service_ip            = each.value.dns_service_ip
    maintenance_auto_upgrade  = try(each.value.maintenance_auto_upgrade,null)
    rbac                      = try(each.value.rbac,"default")
    system_node_pool          = each.value.system_node_pool
    user_node_pool            = each.value.user_node_pool
    outbound_type             = each.value.outbound_type
    private_cluster_enabled   = each.value.private_cluster_enabled
    automatic_channel_upgrade = each.value.automatic_channel_upgrade
    tenant_id                 = local.spn.AzureSPN.CNT_Plus_Tenant.tenant_id
    user_assigned_identity_id = module.UAMI[each.value.user_assigned_identity_id].get_uami_id

    depends_on                = [module.RG]
}