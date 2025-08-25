locals {
  pip_list = {

    "PIP-AGW" = {
      rg       = "RG-KHKIM"
      location = "koreacentral"
      zone     = ["1","2","3"]
      tags = {
        owner = "김교현"
      }
    }

    # "PIP-fw-pip" = {
    #   rg       = "RG-KHKIM"
    #   location = "koreacentral"
    #   tags = {
    #     owner = "김교현"
    #   }
    # }

    # "PIP-fw-mgmt-pip" = {
    #   rg       = "RG-KHKIM"
    #   location = "koreacentral"
    #   tags = {
    #     owner = "김교현"
    #   }
    # }

    "PIP-web1" = {
      rg       = "RG-KHKIM"
      location = "koreacentral"
      tags = {
        owner = "김교현"
      }
    }

    "PIP-Hub" = {
      rg       = "RG-KHKIM"
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