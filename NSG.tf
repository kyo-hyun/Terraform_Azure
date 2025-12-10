locals {
  NSG_list = {
    "nsg-rygus-test" = {
      resource_group = "khkim_rg"
      location       = "koreacentral"

      nsg_rule = {
        "allow-rdp" = {
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "3389"
          source_address_prefixes    = ["218.48.21.223", "1.235.222.130"]
          destination_address_prefix = "*"
        }

        "allow-ssh" = {
          priority                   = 200
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "22"
          source_address_prefixes    = ["218.48.21.223", "1.235.222.130"]
          destination_address_prefix = "*"
        }

        "allow-npm" = {
          priority                   = 202
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "3000"
          source_address_prefixes    = ["218.48.21.223", "1.235.222.130","10.0.5.0/24"]
          destination_address_prefix = "*"
        }

        "allow-http" = {
          priority                   = 300
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "80"
          source_address_prefixes    = ["218.48.21.223", "1.235.222.130","10.0.5.0/24"]
          destination_address_prefix = "*"
        }

        "allow-icmp" = {
          priority                   = 500
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Icmp"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefixes    = ["218.48.21.223", "1.235.222.130"]
          destination_address_prefix = "*"
        }

      }
      tags = {
        owner = "김교현"
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

