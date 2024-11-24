locals {
  os_profile = yamldecode(file("./os_profile.yml"))

  image_map = {
    "ubuntu" = {
      "18_04-lts"       = { publisher = "Canonical", offer = "0001-com-ubuntu-server-bionic" }
      "20_04-lts"       = { publisher = "Canonical", offer = "0001-com-ubuntu-server-focal" }
      "22_04-lts"       = { publisher = "Canonical", offer = "0001-com-ubuntu-server-jammy" }
    }

    "windows" = {
      "2016-datacenter" = { publisher = "MicrosoftWindowsServer", offer = "WindowsServer" }
      "2019-datacenter" = { publisher = "MicrosoftWindowsServer", offer = "WindowsServer" }
    }
  }

  vm_list = {

    "khkim-Windows" = {

        subscription    = "nckr"
        rg              = "khkim_test"
        location        = "koreacentral"
        vnet            = "terraform_vnet"
        subnet          = "sub1"
        ip_address      = "10.0.1.24"

        size            = "Standard_B1ls"
        OsType          = "windows"
        OsImage         = "2019-datacenter"

        data_disk       = {
          0 = {
            size        = 10
          }
        }

        tags = {
            owner = "김교현",
            env   = "windows"
        }
    }

    "khkim-Ubuntu" = {

      subscription      = "nckr"
      rg                = "khkim_test"
      location          = "koreacentral"
      vnet              = "terraform_vnet"
      subnet            = "sub1"
      ip_address        = "10.0.1.25"

      size              = "Standard_B1ls"
      OsType            = "ubuntu"
      OsImage           = "22_04-lts"

      data_disk         = {
        0 = {
          size          = 10
        }

      }

      tags = {
        owner = "김교현",
        env   = "Linux"
      }
    }

  }
}

module "azure_vm" {
  source      = "./module/VM"
  for_each    = local.vm_list
  name        = each.key
  rg          = each.value.rg
  location    = each.value.location
  Os_Type     = each.value.OsType
  os_image    = local.image_map[each.value.OsType][each.value.OsImage]
  sku         = each.value.OsImage
  subnet      = module.vnet[each.value.vnet].get_subnet_id[each.value.subnet]
  ip_address  = each.value.ip_address
  size        = each.value.size
  os_profile  = local.os_profile.profile[each.value.subscription]
  data_disk   = each.value.data_disk
  tags        = each.value.tags
}