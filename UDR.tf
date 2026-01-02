locals {
  udr_list = {
    "agw-udr" = {
      resource_group = "hub_rg"
      location       = "koreacentral"

      route = {
        "route-agw-to-spoke1-via-nids" = {
          address_prefix          = "10.0.0.128/25"
          next_hop_type           = "VirtualAppliance"
          next_hop_in_ip_address  = "10.0.0.36"
        }

        "route-agw-to-spoke2-via-nids" = {
          address_prefix          = "11.0.0.0/25"
          next_hop_type           = "VirtualAppliance"
          next_hop_in_ip_address  = "10.0.0.36"
        }
      }
    }

    "spoke1-aks-lb-udr" = {
      resource_group = "spoke1_rg"
      location       = "koreacentral"

      route = {
        "route-spoke1-aks-lb-to-agw-via-fw" = {
          address_prefix          = "10.0.0.0/27"
          next_hop_type           = "VirtualAppliance"
          next_hop_in_ip_address  = "10.0.0.52"
        }
      }
    }

    "spoke1-aks-udr" = {
      resource_group = "spoke1_rg"
      location       = "koreacentral"

      route = {
        "route-spoke1-aks-to-agw-via-fw" = {
          address_prefix          = "0.0.0.0/0"
          next_hop_type           = "VirtualAppliance"
          next_hop_in_ip_address  = "10.0.0.52"
        }
      }
    }

    "spoke2-aks-lb-udr" = {
      resource_group = "spoke2_rg"
      location       = "koreacentral"

      route = {
        "route-spoke2-aks-lb-to-agw-via-fw" = {
          address_prefix          = "10.0.0.0/27"
          next_hop_type           = "VirtualAppliance"
          next_hop_in_ip_address  = "10.0.0.52"
        }
      }
    }

    "spoke2-aks-udr" = {
      resource_group = "spoke2_rg"
      location       = "koreacentral"

      route = {
        "route-spoke2-aks-to-agw-via-fw" = {
          address_prefix          = "0.0.0.0/0"
          next_hop_type           = "VirtualAppliance"
          next_hop_in_ip_address  = "10.0.0.52"
        }
      }
    }
  }
}

module "UDR" {
  source    = "./module/UDR"
  for_each  = local.udr_list
  name           = each.key
  resource_group = each.value.resource_group
  location       = each.value.location
  route          = each.value.route
  depends_on = [module.RG]
}