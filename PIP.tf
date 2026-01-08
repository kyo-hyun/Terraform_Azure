locals {
  pip_list = {

    "PIP-AGW" = {
      rg       = "hub_rg"
      location = "koreacentral"
      zone     = ["1","2","3"]
      tags = {
        Env = "Hub"
      }
    }

    "PIP-n-ids-1-pip" = {
      rg       = "hub_rg"
      location = "koreacentral"
      tags = {
        Env = "Hub"
      }
    }

    "PIP-n-ids-2-pip" = {
      rg       = "hub_rg"
      location = "koreacentral"
      tags = {
        Env = "Hub"
      }
    }
  }
}

module "pip" {
  for_each = local.pip_list
  source   = "./module/PIP"
  name     = each.key
  rg       = each.value.rg
  location = each.value.location
  sku      = try(each.value.sku,"Standard")
  zone     = try(each.value.zone,null)
  tags     = each.value.tags

  depends_on = [module.RG]
}