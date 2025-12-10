locals {
  udr_list = {
    
    # "lb-udr" = {
    #   resource_group = "KHKIM_RG"
    #   location       = "koreacentral"

    #   route = {
    #     "udr-aks-to-fw" = {
    #       address_prefix          = "0.0.0.0/0"
    #       next_hop_type           = "VirtualAppliance"
    #       next_hop_in_ip_address  = "10.0.0.4"
    #     }
    #     "udr-1" = {
    #       address_prefix          = "22.0.0.0/24"
    #       next_hop_type           = "Internet"
    #     }
    #   }
    # }

    "aks-node-udr" = {
      resource_group = "KHKIM_RG"
      location       = "koreacentral"

      route = {
        "udr-aks-to-fw" = {
          address_prefix          = "0.0.0.0/0"
          next_hop_type           = "VirtualAppliance"
          next_hop_in_ip_address  = "10.0.0.4"
        }
      }
    }

    # "backend-udr" = {
    #   resource_group = "KHKIM_RG"
    #   location       = "koreacentral"

    #   route = {
    #     "udr-aks-to-fw" = {
    #       address_prefix          = "0.0.0.0/0"
    #       next_hop_type           = "VirtualAppliance"
    #       next_hop_in_ip_address  = "10.0.0.4"
    #     }
    #   }
    # }

    # "agw-udr" = {
    #   resource_group = "KHKIM_RG"
    #   location       = "koreacentral"

    #   route = {
    #     "udr-aks-to-fw" = {
    #       address_prefix          = "0.0.0.0/0"
    #       next_hop_type           = "VirtualAppliance"
    #       next_hop_in_ip_address  = "10.0.0.4"
    #     }
    #   }
    # }

    # "aks-api-udr" = {
    #   resource_group = "KHKIM_RG"
    #   location       = "koreacentral"

    #   route = {
    #     "udr-aks-to-fw" = {
    #       address_prefix          = "0.0.0.0/0"
    #       next_hop_type           = "VirtualAppliance"
    #       next_hop_in_ip_address  = "10.0.0.4"
    #     }
    #   }
    # }

    # "vm-udr" = {
    #   resource_group = "KHKIM_RG"
    #   location       = "koreacentral"

    #   route = {
    #     "udr-aks-to-fw" = {
    #       address_prefix          = "0.0.0.0/0"
    #       next_hop_type           = "VirtualAppliance"
    #       next_hop_in_ip_address  = "10.0.0.4"
    #     }
    #   }
    # }

    # "vm2-udr" = {
    #   resource_group = "KHKIM_RG"
    #   location       = "koreacentral"

    #   route = {
    #     "udr-aks-to-fw" = {
    #       address_prefix          = "0.0.0.0/0"
    #       next_hop_type           = "VirtualAppliance"
    #       next_hop_in_ip_address  = "10.0.0.4"
    #     }
    #   }
    # }
    
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