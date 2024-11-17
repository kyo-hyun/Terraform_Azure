locals {
  rg_list = {
    "khkim_test" = {
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