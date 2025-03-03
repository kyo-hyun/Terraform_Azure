locals {
  NSG_list = {
    "nsg_terraform" = {
      resource_group = "RG-rygus-terraform"
      location       = "koreacentral"
      nsg_rule = {
        "allow-rdp" = {
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "3389"
          source_address_prefixes    = ["211.117.84.44", "1.235.222.130"]
          destination_address_prefix = "*"
        }

        "allow-ssh" = {
          priority                   = 200
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "22"
          source_address_prefixes    = ["211.117.84.44", "1.235.222.130"]
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