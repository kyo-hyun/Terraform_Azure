locals {
  vnet_list = {
    "vnet-khkim-hub" = {
      location       = "koreacentral"
      resource_group = "RG-Test"
      address_space  = ["10.0.0.0/16"]

      subnets = {
        "snet-hub1" = {
          address_prefixes = ["10.0.1.0/24"]
        }

        "agw-snet" = {
           address_prefixes = ["10.0.3.0/24"]
        }
        
      }

      tags = {
        owner = "김교현"
      }
    }

    "vnet-aks-test" = {
      location       = "koreacentral"
      resource_group = "RG-Test"
      address_space  = ["192.0.0.0/16"]

      subnets = {
        "snet-cluster" = {
          address_prefixes = ["192.0.1.0/24"]
        }

        "snet-kubectl" = {
          address_prefixes = ["192.0.3.0/24"]
        }

        "snet-appgw" = {
          address_prefixes = ["192.0.4.0/24"]
        }

        "AzureFirewallSubnet" = {
          address_prefixes = ["192.0.5.0/24"]
        }
        
      }

      tags = {
        owner = "김교현"
      }
    }

    "vnet-aks" = {
      location       = "koreacentral"
      resource_group = "RG-Test"
      address_space  = ["10.0.0.0/16"]

      subnets = {

        "AzureFirewallSubnet" = {
          address_prefixes = ["10.0.5.0/24"]
        }

        "snet-cluster" = {
          address_prefixes = ["10.0.6.0/24"]
        }
        
      }

      tags = {
        owner = "김교현"
      }
    }

    # "vnet-khkim-spoke1" = {
    #   location       = "koreacentral"
    #   resource_group = "RG-KHKIM"
    #   address_space  = ["11.0.0.0/16"]

    #   subnets = {
    #     "snet-spoke1" = {
    #       address_prefixes = ["11.0.1.0/24"]
    #     }
    #   }

    #   tags = {
    #     owner = "김교현"
    #   }
    # }

    # "vnet-khkim-spoke2" = {
    #   location       = "koreacentral"
    #   resource_group = "RG-KHKIM"
    #   address_space  = ["12.0.0.0/16"]

    #   subnets = {
    #     "snet-spoke2" = {
    #       address_prefixes = ["12.0.1.0/24"]
    #     }
    #   }

    #   tags = {
    #     owner = "김교현"
    #   }
    # }

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