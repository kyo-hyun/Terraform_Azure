locals {
  pip_list = {
    "pip-khkim-ubuntu" = {
      rg       = "RG-rygus-terraform"
      location = "koreacentral"
      tags = {
        owner = "김교현"
      }
    }
    
    "PIP-NAT" = {
      rg       = "RG-rygus-terraform"
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
  tags     = each.value.tags

  depends_on = [module.RG]
}