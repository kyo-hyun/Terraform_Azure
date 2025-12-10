locals {
  pip_list = {

    # "PIP-LB" = {
    #   rg       = "KHKIM_RG"
    #   location = "koreacentral"
    #   zone     = ["1","2","3"]
    #   tags = {
    #     owner = "김교현"
    #   }
    # }

    # "PIP-fw-pip" = {
    #   rg       = "KHKIM_RG"
    #   location = "koreacentral"
    #   tags = {
    #     owner = "김교현"
    #   }
    # }

    # "PIP-fw-mgmt-pip" = {
    #   rg       = "KHKIM_RG"
    #   location = "koreacentral"
    #   tags = {
    #     owner = "김교현"
    #   }
    # }

    # "PIP-Master" = {
    #   rg       = "KHKIM_RG"
    #   location = "koreacentral"
    #   tags = {
    #     owner = "김교현"
    #   }
    # }

    "PIP-worker1" = {
      rg       = "KHKIM_RG"
      location = "koreacentral"
      tags = {
        owner = "김교현"
      }
    }

    "PIP-worker2" = {
      rg       = "KHKIM_RG"
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