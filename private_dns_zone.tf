locals {
  dns_zone_list = {
    "privatelink.koreacentral.azmk8s.io" = {
        rg   = "Hub_rg"
        vnet = ["hub-vnet"]
    }

    "privatelink.file.core.windows.net" = {
        rg   = "Hub_rg"
        vnet = ["spoke1-vnet","spoke2-vnet"]
    }
  }
}

module "DNS_Zone" {
  source     = "./module/DNS_Zone"
  for_each   = local.dns_zone_list
  name       = each.key
  rg         = each.value.rg
  vnet_list  = {for vnet in each.value.vnet : vnet => module.vnet[vnet].get_vnet_id}

  depends_on = [module.RG]
}