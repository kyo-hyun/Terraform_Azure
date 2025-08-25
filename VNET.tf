locals {

  vnet_list = {

    "vnet-khkim-hub" = {
      location       = "koreacentral"
      resource_group = "RG-KHKIM"
      address_space  = ["10.0.0.0/24"]

      subnets = {
        "AzureFirewallSubnet" = {
          address_prefixes = ["10.0.0.0/26"]
        }

        "lb-subnet" = {
          address_prefixes = ["10.0.0.64/28"]
        }

        "aks-node-subnet" = {
          address_prefixes = ["10.0.0.128/27"]
        }

        "backend-subnet" = {
          address_prefixes = ["10.0.0.160/29"]
        }

        "agw-subnet" = {
          address_prefixes = ["10.0.0.168/29"]
        }

        "aks-api-subnet" = {
          address_prefixes = ["10.0.0.224/27"]
        }
      }

      tags = {
        owner = "김교현"
      }
    }

    "vnet-khkim-spoke" = {
      location       = "koreacentral"
      resource_group = "RG-KHKIM"
      address_space  = ["12.0.0.0/16"]

      subnets = {
        "aks-cluster-subnet" ={
          address_prefixes = ["12.0.2.0/24"]
        }

        "aks-lb-subnet" ={
          address_prefixes = ["12.0.3.0/24"]
        }

        "test-vm-subnet" ={
          address_prefixes = ["12.0.4.0/24"]
        }

        "AzureFirewallSubnet" ={
          address_prefixes = ["12.0.5.0/24"]
        }
      }

      tags = {
        owner = "김교현"
      }
    }
    
    "vnet-hub" = {
          location       = "koreacentral"
          resource_group = "RG-KHKIM"
          address_space  = ["11.0.0.0/24"]

          subnets = {
            "GatewaySubnet" ={
              address_prefixes = ["11.0.0.0/26"]
            }

            "vm-subnet" ={
              address_prefixes = ["11.0.0.64/28"]
            }
          }

          tags = {
            owner = "김교현"
          }
        }


    "vnet-spoke" = {
          location       = "koreacentral"
          resource_group = "RG-KHKIM"
          address_space  = ["12.0.0.0/24"]

          subnets = {
            "vm-subnet" ={
              address_prefixes = ["12.0.0.0/28"]
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
  subnets        = each.value.subnets
  address_space  = each.value.address_space
  resource_group = each.value.resource_group
  tags           = each.value.tags

  depends_on = [module.RG]
}