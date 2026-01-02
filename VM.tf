locals {
  os_profile = yamldecode(file("./os_profile.yml"))

  image_map = {
    "ubuntu" = {
      "18_04-lts" = { publisher = "Canonical", offer = "0001-com-ubuntu-server-bionic" }
      "20_04-lts" = { publisher = "Canonical", offer = "0001-com-ubuntu-server-focal" }
      "22_04-lts" = { publisher = "Canonical", offer = "0001-com-ubuntu-server-jammy" }
    }

    "Windows" = {
      "2016-datacenter" = { publisher = "MicrosoftWindowsServer", offer = "WindowsServer" }
      "2019-datacenter" = { publisher = "MicrosoftWindowsServer", offer = "Wintf dowsServer" }
      "2022-datacenter" = { publisher = "MicrosoftWindowsServer", offer = "WindowsServer" }
      "2025-datacenter-azure-edition" = { publisher = "MicrosoftWindowsServer", offer = "WindowsServer" }
    }
  }

  vm_list = {
    "n-ids1" = {
      rg                  = "Hub_rg"
      location            = "koreacentral"
      vnet                = "hub-vnet"
      subnet              = "n-ids-untrust-snet"
      ip_address          = "10.0.0.37"
      size                = "Standard_F2s_v2"
      os_disk_type        = "Standard_LRS"
      OsType              = "ubuntu"
      OsImage             = "22_04-lts"
      os_disk_size        = 32

      data_disk           = {

      }

      tags = {
        Env = "Hub"
      }
    }

    "n-ids2" = {
      rg                  = "Hub_rg"
      location            = "koreacentral"
      vnet                = "hub-vnet"
      subnet              = "n-ids-untrust-snet"
      ip_address          = "10.0.0.38"
      size                = "Standard_F2s_v2"
      os_disk_type        = "Standard_LRS"
      OsType              = "ubuntu"
      OsImage             = "22_04-lts"
      os_disk_size        = 32

      data_disk           = {

      }

      tags = {
        Env = "Hub"
      }
    }

    "waf1" = {
      rg                  = "Hub_rg"
      location            = "koreacentral"
      vnet                = "hub-vnet"
      subnet              = "waf-snet"
      ip_address          = "10.0.0.68"
      size                = "Standard_F2s_v2"
      os_disk_type        = "Standard_LRS"
      OsType              = "ubuntu"
      OsImage             = "22_04-lts"
      os_disk_size        = 32

      data_disk           = {

      }

      tags = {
        Env = "Hub"
        
      }
    }

    "waf2" = {
      rg                  = "Hub_rg"
      location            = "koreacentral"
      vnet                = "hub-vnet"
      subnet              = "waf-snet"
      ip_address          = "10.0.0.69"
      size                = "Standard_F2s_v2"
      os_disk_type        = "Standard_LRS"
      OsType              = "ubuntu"
      OsImage             = "22_04-lts"
      os_disk_size        = 32

      data_disk           = {

      }

      tags = {
        Env = "Hub"
      }
    }
  }
}

module "azure_vm" {
  source              = "./module/VM/"
  for_each            = local.vm_list
  name                = each.key
  VM_Type             = try(each.value.VM_Type,"new")
  rg                  = each.value.rg
  location            = each.value.location
  Os_Type             = each.value.OsType
  os_image            = try(local.image_map[each.value.OsType][each.value.OsImage],null)
  osdisk_size         = each.value.os_disk_size
  sku                 = try(each.value.OsImage,null)
  subnet              = module.vnet[each.value.vnet].get_subnet_id[each.value.subnet]
  ip_address          = each.value.ip_address
  public_ip           = try(module.pip[each.value.public_ip].get_pip_id,null)
  nsg_id              = try(module.NSG[each.value.nsg].get_nsg_id,null)
  nsg                 = try(each.value.nsg,null)
  boot_diag_stg       = try(each.value.boot_diag_stg,null)
  boot_diag_stg_rg    = try(each.value.boot_diag_stg_rg,null)
  cse_stg_rg          = try(each.value.cse_stg_rg,null)
  cse_stg             = try(each.value.cse_stg,null)
  vhd_stg_rg          = try(each.value.vhd_stg_rg,null)
  vhd_stg             = try(each.value.vhd_stg,null)
  ip_forwarding       = try(each.value.ip_forwarding, false)
  automatic_updates   = try(each.value.automatic_updates, null)
  patch_mode          = try(each.value.patch_mode,"Manual")     
  size                = each.value.size
  os_disk_type        = each.value.os_disk_type
  script              = try(each.value.script,null)
  source_snapshot     = try(each.value.source_snapshot,null)
  source_vhd          = try(each.value.source_vhd,null)
  os_profile          = local.os_profile.profile["test1"]
  data_disk           = each.value.data_disk
  tags                = each.value.tags

  depends_on = [module.RG]
}