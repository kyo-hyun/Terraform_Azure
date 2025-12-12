locals {

  vnet_list = {
    "Hub-vnet" = {
      location       = "koreacentral"
      resource_group = "khkim_rg"
      address_space  = ["10.0.0.0/16"]

      subnets = {
        "AzureFirewallSubnet" = {
          address_prefixes = ["10.0.0.0/24"]
        }

        "AzureFirewallManagementSubnet" = {
          address_prefixes = ["10.0.1.0/24"]
        }

        # "lb-subnet" = {
        #   address_prefixes = ["10.0.2.0/24"]
        #   nsg              = "nsg-rygus-test"
        # }

        "aks-node-subnet" = {
          address_prefixes = ["10.0.3.0/24"]
          #udr              = "aks-node-udr" 
        }

        # "backend-subnet" = {
        #   address_prefixes    = ["10.0.4.0/24"]
        #   service_delegation  = "GitHub.Network/networkSettings"
        # }

        # "agw-subnet" = {
        #   address_prefixes    = ["10.0.5.0/24"]
        #   service_delegation  = "Microsoft.Network/applicationGateways"
        #   #udr                 = "agw-udr"
        # }

        # "aks-api-subnet" = {
        #   address_prefixes    = ["10.0.6.0/24"]
        #   #udr                 = "backend-udr"
        # }

        "vm-subnet" = {
          address_prefixes    = ["10.0.7.0/24"]
        }

        "vm2-subnet" = {
          address_prefixes    = ["10.0.8.0/24"]
        }

        # "apim-subnet" = {
        #   address_prefixes    = ["10.0.9.0/24"]
        #   nsg                 = "nsg-rygus-test"
        # }        

        # "apim-outbound-subnet" = {
        #   address_prefixes    = ["10.0.10.0/24"]
        #   nsg                 = "nsg-rygus-test"
        #   service_delegation  = "Microsoft.Web/serverFarms"
        # }              

        "unique-nic-snet" = {
          address_prefixes    = ["10.0.11.0/24"]
          nsg                 = "nsg-rygus-test"
        }      
      }

      tags = {
        owner = "김교현"
      }
    }

    "spoke1-vnet" = {
      location       = "koreacentral"
      resource_group = "khkim_rg"
      address_space  = ["11.0.0.0/16"]

      subnets = {
        "vm-snet1" = {
          address_prefixes = ["11.0.0.0/24"]
        }

        "vm-snet2" = {
          address_prefixes = ["11.0.1.0/24"]
          
        }

        "unique-snet" = {
          address_prefixes = ["11.0.2.0/24"]
        }
      }

      tags = {
        owner = "김교현"
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