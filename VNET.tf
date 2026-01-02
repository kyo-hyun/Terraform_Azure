locals {
  vnet_list = {
    "hub-vnet" = {
      location       = "koreacentral"
      resource_group = "Hub_rg"
      address_space  = ["10.0.0.0/25"]

      subnets = {
        "agw-snet" = {
          address_prefixes    = ["10.0.0.0/27"]
          service_delegation  = "Microsoft.Network/applicationGateways"
          udr                 = "agw-udr"
          nsg                 = "agw-snet-nsg"
        }

        "n-ids-untrust-snet" = {
          address_prefixes    = ["10.0.0.32/28"]
          nsg                 = "n-ids-untrust-snet-nsg"
        }

        "n-ids-trust-snet" = {
          address_prefixes    = ["10.0.0.48/28"]
          nsg                 = "n-ids-trust-snet-nsg"
        }

        "waf-snet" = {
          address_prefixes    = ["10.0.0.64/28"]
          nsg                 = "waf-snet-nsg"
        }

        "mgmt-snet" = {
          address_prefixes    = ["10.0.0.80/28"]
          nsg                 = "mgmt-snet-nsg"
        }        
      }

      tags = {
        env   = "Hub"
      }
    }

    "spoke1-vnet" = {
      location       = "koreacentral"
      resource_group = "Spoke1_rg"
      address_space  = ["10.0.0.128/25"]

      subnets = {
        "aks-lb-sent" = {
          address_prefixes = ["10.0.0.160/28"]
          udr              = "spoke1-aks-lb-udr"
          nsg              = "spoke1-aks-lb-sent-nsg"
        }

        "aks-sent" = {
          address_prefixes = ["10.0.0.128/27"]
          udr              = "spoke1-aks-udr"
          nsg              = "spoke1-aks-sent-nsg"
          
        }

        "pep-snet" = {
          address_prefixes = ["10.0.0.176/28"]
          nsg              = "spoke1-pep-sent-nsg"
        }
      }

      tags = {
        env = "Spoke1"
      }

    }

    "spoke2-vnet" = {
      location       = "koreacentral"
      resource_group = "Spoke2_rg"
      address_space  = ["11.0.0.0/25"]

      subnets = {
        "aks-lb-sent" = {
          address_prefixes = ["11.0.0.32/28"]
          udr              = "spoke2-aks-lb-udr"
          nsg              = "spoke2-aks-lb-sent-nsg"
        }

        "aks-sent" = {
          address_prefixes = ["11.0.0.0/27"]
          udr              = "spoke2-aks-udr"
          nsg              = "spoke2-aks-sent-nsg"
        }

        "pep-snet" = {
          address_prefixes = ["11.0.0.48/28"]
          nsg              = "spoke2-pep-sent-nsg"
        }
      }

      tags = {
        env = "Spoke2"
      }

    }    
  }
}

module "vnet" {
  source         = "./module/VNET"
  for_each       = local.vnet_list
  name           = each.key
  location       = each.value.location
  subnets        = [
    for subnet_key, subnet_value in each.value.subnets : {
      subnet_name        = subnet_key
      address_prefixes   = subnet_value.address_prefixes
      service_delegation = try(subnet_value.service_delegation, null)
      nsg                = lookup(subnet_value, "nsg", null)
      nsg_id             = lookup(subnet_value, "nsg", null) != null ? module.NSG[subnet_value.nsg].get_nsg_id : null
      udr                = lookup(subnet_value, "udr", null)
      udr_id             = lookup(subnet_value, "udr", null) != null ? module.UDR[subnet_value.udr].get_udr_id : null
    }
  ]
  address_space  = each.value.address_space
  resource_group = each.value.resource_group
  tags           = try(each.value.tags,null)

  depends_on = [module.RG]
}