locals {
  pip_list = {
    "PIP_spoke1" = {
      rg       = "RG-rygus"
      location = "koreacentral"
      tags = {
        owner = "김교현"
      }
    }

    "PIP_spoke2" = {
      rg       = "RG-rygus"
      location = "koreacentral"
      tags = {
        owner = "김교현"
      }
    }

    "PIP_fw_mgmt" = {
      rg       = "RG-rygus"
      location = "koreacentral"
      tags = {
        owner = "김교현"
      }
    }

    "PIP_fw" = {
      rg       = "RG-rygus"
      location = "koreacentral"
      tags = {
        owner = "김교현"
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