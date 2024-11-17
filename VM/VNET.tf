locals {
  vnet_list = {
    "terraform_vnet" = {
      location       = "koreacentral"
      resource_group = "khkim_test"
      address_space  = ["10.0.0.0/16"]

      subnets = {
        "sub1" = {
          address_prefixes = ["10.0.1.0/24"]
        }
      }

      tags = {
        owner = "김교현"
      }
    }
  }
}

# module "vnet" {
#   source         = "./module/VNET"
#   for_each       = local.vnet_list
#   name           = each.key
#   location       = each.value.location
#   subnets        = each.value.subnets
#   address_space  = each.value.address_space
#   resource_group = each.value.resource_group
#   tags           = each.value.tags
# }