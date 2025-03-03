locals {
  pip_list = {
    "PIP_NEW_WIN" = {
      rg       = "RG-rygus-terraform"
      location = "koreacentral"
      tags = {
        owner = "김교현",
        os = "Windows"
      }
    }

    "PIP_NEW_LINUX" = {
      rg       = "RG-rygus-terraform"
      location = "koreacentral"
      tags = {
        owner = "김교현",
        os = "Linux"
      }
    }

    "PIP_replica" = {
      rg       = "RG-rygus-terraform"
      location = "koreacentral"
      tags = {
        owner = "김교현",
        os = "replica"
      }
    }

    "PIP_region_replica" = {
      rg       = "RG-rygus-terraform"
      location = "koreacentral"
      tags = {
        owner = "김교현",
        os = "region_replica"
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
  tags     = each.value.tags

  depends_on = [module.RG]
}