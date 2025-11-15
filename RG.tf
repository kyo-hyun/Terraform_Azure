locals {
  rg_list = {
    "khkim_rg" = {
      location = "koreacentral"
      tags     = {
        사용자 = "김교현"
        용도   = "테스트"
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