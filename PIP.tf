locals {
  pip_list = {
    # "PIP-AGW" = {
    #   rg       = "RG-Test"
    #   location = "koreacentral"
    #   zone     = ["1","2","3"]
    #   tags = {
    #     owner = "김교현"
    #   }
    # }

    # "PIP-FW" = {
    #   rg       = "RG-Test"
    #   location = "koreacentral"
    #   zone     = ["1","2","3"]
    #   tags = {
    #     owner = "김교현"
    #   }
    # }

    # "PIP_back1" = {
    #   rg       = "RG-Test"
    #   location = "koreacentral"
    #   tags = {
    #     owner = "김교현"
    #   }
    # }
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