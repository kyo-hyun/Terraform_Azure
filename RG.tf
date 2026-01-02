locals {
  rg_list = {
    "Hub_rg" = {
      location = "koreacentral"
      tags     = {
        Env = "Hub"
      }
    }

    "Spoke1_rg" = {
      location = "koreacentral"
      tags     = {
        Env = "Spoke1"
      }
    }

    "Spoke2_rg" = {
      location = "koreacentral"
      tags     = {
        Env = "Spoke2"
      }
    }
  }
}

module "RG" {
  source   = "./module/RG"
  for_each = local.rg_list
  name     = each.key
  location = each.value.location
  tags     = each.value.tags
}