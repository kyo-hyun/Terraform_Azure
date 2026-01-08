locals {
  uami_list = {
    "spoke1-uami" = {
      resource_group = "spoke1_rg"
      location       = "koreacentral"
      assignments = [
        {
          scope     = "/subscriptions/86d6e9f1-1227-4473-98f5-7920e3e02eef/resourceGroups/Hub_rg/providers/Microsoft.Network/privateDnsZones/privatelink.koreacentral.azmk8s.io"
          role_name = "Private DNS Zone Contributor"
        },
        {
          scope     = "/subscriptions/86d6e9f1-1227-4473-98f5-7920e3e02eef/resourceGroups/Spoke1_rg/providers/Microsoft.Network/virtualNetworks/spoke1-vnet"
          role_name = "Network Contributor"
        },
        {
          scope     = "/subscriptions/86d6e9f1-1227-4473-98f5-7920e3e02eef/resourceGroups/Spoke2_rg/providers/Microsoft.Network/virtualNetworks/spoke2-vnet"
          role_name = "Network Contributor"
        }
      ]
    }

    "spoke2-uami" = {
      resource_group = "spoke2_rg"
      location       = "koreacentral"
      assignments = [
        {
          scope     = "/subscriptions/86d6e9f1-1227-4473-98f5-7920e3e02eef/resourceGroups/Hub_rg/providers/Microsoft.Network/privateDnsZones/privatelink.koreacentral.azmk8s.io"
          role_name = "Private DNS Zone Contributor"
        },
        {
          scope     = "/subscriptions/86d6e9f1-1227-4473-98f5-7920e3e02eef/resourceGroups/Spoke1_rg/providers/Microsoft.Network/virtualNetworks/spoke1-vnet"
          role_name = "Network Contributor"
        },
        {
          scope     = "/subscriptions/86d6e9f1-1227-4473-98f5-7920e3e02eef/resourceGroups/Spoke2_rg/providers/Microsoft.Network/virtualNetworks/spoke2-vnet"
          role_name = "Network Contributor"
        }
      ]
    }
  }
}

module "UAMI" {
  source   = "./module/UAMI"
  for_each = local.uami_list

  name           = each.key
  resource_group = each.value.resource_group
  location       = each.value.location
  assignments    = each.value.assignments

  depends_on = [module.RG]
}