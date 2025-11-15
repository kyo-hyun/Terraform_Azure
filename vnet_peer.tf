locals {
  vnet_peerings = {
    # "peer-hub-spokeA" = {
    #     local_vnet_rg   = "khkim_rg"
    #     local_vnet      = "vnet-khkim-hub"
    #     remote_vnet_rg  = "khkim_rg"
    #     remote_vnet     = "remote-vnet"
    # }
  }
}

module "vnet_peering_intra" {
  source          = "./module/peering"
  for_each        = local.vnet_peerings

  local_vnet_rg   = each.value.local_vnet_rg
  local_vnet      = each.value.local_vnet
  local_vnet_id   = module.vnet[each.value.local_vnet].get_vnet_id
  remote_vnet_rg  = each.value.remote_vnet_rg
  remote_vnet     = each.value.remote_vnet
  remote_vnet_id  = module.vnet[each.value.remote_vnet].get_vnet_id
}