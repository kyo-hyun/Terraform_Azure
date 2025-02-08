locals {
  rg_list = {
    "RG-rygus-terraform" = {
      location = "koreacentral"
    }
  }
}

module "RG" {
  source   = "./module/RG"
  for_each = local.rg_list
  name     = each.key
  location = each.value.location
}