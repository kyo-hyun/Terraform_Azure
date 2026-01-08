locals {
  vnet_peerings = {
    "peer-hub-spoke1" = {
        local_vnet_rg   = "Hub_rg"
        local_vnet      = "hub-vnet"
        remote_vnet_rg  = "Spoke1_rg"
        remote_vnet     = "spoke1-vnet"
    }
    "peer-hub-spoke2" = {
        local_vnet_rg   = "Hub_rg"
        local_vnet      = "hub-vnet"
        remote_vnet_rg  = "Spoke2_rg"
        remote_vnet     = "spoke2-vnet"
    }
  }
}

module "vnet_peering_intra" {
  source          = "./module/Peering"
  for_each        = local.vnet_peerings

  local_vnet_rg   = each.value.local_vnet_rg
  local_vnet      = each.value.local_vnet
  local_vnet_id   = module.vnet[each.value.local_vnet].get_vnet_id
  remote_vnet_rg  = each.value.remote_vnet_rg
  remote_vnet     = each.value.remote_vnet
  remote_vnet_id  = module.vnet[each.value.remote_vnet].get_vnet_id
}