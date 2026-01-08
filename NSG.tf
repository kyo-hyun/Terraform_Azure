locals {
  NSG_list = {
    "agw-snet-nsg" = {
      resource_group = "Hub_rg"
      location       = "koreacentral"

      nsg_rule = {
        "inbound-allow-http" = {
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = ["80","443"]
          source_address_prefixes    = ["*"]
          destination_address_prefix = "*"
        }

        "inbound-allow-gw-manager" = {
          priority                   = 200
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = ["65200-65535"]
          source_address_prefixes    = ["*"]
          destination_address_prefix = "*"
        }
      }
      tags = {
        Env = "Hub"
      }
    }

    "n-ids-untrust-snet-nsg" = {
      resource_group = "Hub_rg"
      location       = "koreacentral"

      nsg_rule = {
        "inbound-allow-home" = {
          priority                   = 1000
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = ["22"]
          source_address_prefixes    = ["218.48.21.223"]
          destination_address_prefix = "*"
        }

        "inbound-allow-agw" = {
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = ["80"]
          source_address_prefixes    = ["10.0.0.0/27"]
          destination_address_prefix = "*"
        }
      }
      tags = {
        Env = "Hub"
      }
    }

    "n-ids-trust-snet-nsg" = {
      resource_group = "Hub_rg"
      location       = "koreacentral"

      nsg_rule = {

      }
      tags = {
        Env = "Hub"
      }
    }

    "waf-snet-nsg" = {
      resource_group = "Hub_rg"
      location       = "koreacentral"

      nsg_rule = {
        "inbound-allow-agw" = {
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = ["80"]
          source_address_prefixes    = ["10.0.0.0/27"]
          destination_address_prefix = "*"
        }
      }
      tags = {
        Env = "Hub"
      }
    }

    "mgmt-snet-nsg" = {
      resource_group = "Hub_rg"
      location       = "koreacentral"

      nsg_rule = {
        "inbound-allow-spoke1" = {
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = ["80"]
          source_address_prefixes    = ["10.0.0.128/25"]
          destination_address_prefix = "*"
        }

        "inbound-allow-spoke2" = {
          priority                   = 110
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = ["80"]
          source_address_prefixes    = ["11.0.0.0/25"]
          destination_address_prefix = "*"
        }

      }

      tags = {
        Env = "Hub"
      }
    }

    "spoke1-aks-lb-snet-nsg" = {
      resource_group = "spoke1_rg"
      location       = "koreacentral"

      nsg_rule = {
        "inbound-allow-agw" = {
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = ["80"]
          source_address_prefixes    = ["10.0.0.0/27"]
          destination_address_prefix = "*"
        }
      }

      tags = {
        Env = "Spoke1"
      }
    }

    "spoke1-aks-snet-nsg" = {
      resource_group = "spoke1_rg"
      location       = "koreacentral"

      nsg_rule = {
        "inbound-allow-mgmt" = {
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = ["443"]
          source_address_prefixes    = ["10.0.0.80/28"]
          destination_address_prefix = "*"
        }
      }

      tags = {
        Env = "Spoke1"
      }
    }

    "spoke1-pep-snet-nsg" = {
      resource_group = "spoke1_rg"
      location       = "koreacentral"

      nsg_rule = {
        "inbound-allow-aks" = {
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = ["3389","443"]
          source_address_prefixes    = ["10.0.0.128/27"]
          destination_address_prefix = "*"
        }
      }

      tags = {
        Env = "Spoke2"
      }
    }

    "spoke2-aks-lb-snet-nsg" = {
      resource_group = "spoke2_rg"
      location       = "koreacentral"

      nsg_rule = {
        "inbound-allow-agw" = {
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = ["80"]
          source_address_prefixes    = ["10.0.0.0/27"]
          destination_address_prefix = "*"
        }
      }

      tags = {
        Env = "Spoke2"
      }
    }

    "spoke2-aks-snet-nsg" = {
      resource_group = "spoke2_rg"
      location       = "koreacentral"

      nsg_rule = {
        "inbound-allow-mgmt" = {
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = ["443"]
          source_address_prefixes    = ["10.0.0.80/28"]
          destination_address_prefix = "*"
        }
      }

      tags = {
        Env = "Spoke2"
      }
    }

    "spoke2-pep-snet-nsg" = {
      resource_group = "spoke2_rg"
      location       = "koreacentral"

      nsg_rule = {
        "inbound-allow-aks" = {
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = ["3389","443"]
          source_address_prefixes    = ["11.0.0.0/27"]
          destination_address_prefix = "*"
        }

        "inbound-deny-all" = {
          priority                   = 4096
          direction                  = "Inbound"
          access                     = "Deny"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = ["*"]
          source_address_prefixes    = ["0.0.0.0/0"]
          destination_address_prefix = "*"
        }
      }

      tags = {
        Env = "Spoke2"
      }
    }
  }
}

module "NSG" {
  source         = "./module/NSG"
  for_each       = local.NSG_list
  name           = each.key
  resource_group = each.value.resource_group
  location       = each.value.location
  nsg_rule       = each.value.nsg_rule

  depends_on = [module.RG]
}

