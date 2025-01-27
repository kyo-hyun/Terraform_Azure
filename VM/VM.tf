locals {
  os_profile = yamldecode(file("./os_profile.yml"))

  image_map = {
    "ubuntu" = {
      "18_04-lts" = { publisher = "Canonical", offer = "0001-com-ubuntu-server-bionic" }
      "20_04-lts" = { publisher = "Canonical", offer = "0001-com-ubuntu-server-focal" }
      "22_04-lts" = { publisher = "Canonical", offer = "0001-com-ubuntu-server-jammy" }
    }

    "windows" = {
      "2016-datacenter" = { publisher = "MicrosoftWindowsServer", offer = "WindowsServer" }
      "2019-datacenter" = { publisher = "MicrosoftWindowsServer", offer = "WindowsServer" }
    }
  }

  vm_list = {

    "khkim-Windows" = {
        subscription        = "nckr"
        rg                  = "RG-rygus-terraform"
        location            = "koreacentral"
        vnet                = "terraform_vnet"
        subnet              = "sub1"
        ip_address          = "10.0.1.24"
        public_ip           = null
        nsg_id              = "NSG-rygus-test"
        storage_account     = "rygussa"
        storage_account_rg  = "rygus-sa-rg"
        size                = "Standard_B1ls"
        os_disk_type        = "Standard_LRS"
        OsType              = "windows"
        OsImage             = "2019-datacenter"

        data_disk           = {
          0 = {
            size            = 128
            type            = "Standard_LRS"
          }
        }

        tags = {
            owner = "김교현",
            env   = "windows"
        }
    }

     "khkim-Ubuntu" = {

        subscription        = "nckr"
        rg                  = "RG-rygus-terraform"
        location            = "koreacentral"
        vnet                = "terraform_vnet"
        subnet              = "sub1"
        ip_address          = "10.0.1.25"
        public_ip           = "pip-khkim-ubuntu"
        nsg_id              = "NSG-rygus-test"
        storage_account     = "rygussa"
        storage_account_rg  = "rygus-sa-rg"

        size                = "Standard_B1ls"
        os_disk_type        = "Standard_LRS"
        OsType              = "ubuntu"
        OsImage             = "22_04-lts"

        data_disk           = {
          0 = {
            size            = 10
            type            = "Standard_LRS"
          }

        }

       tags = {
         owner = "김교현",
         env   = "Terraform"
       }
     }

  }
}

module "azure_vm" {
  source              = "./module/VM"
  for_each            = local.vm_list
  name                = each.key
  rg                  = each.value.rg
  location            = each.value.location
  Os_Type             = each.value.OsType
  os_image            = local.image_map[each.value.OsType][each.value.OsImage]
  sku                 = each.value.OsImage
  subnet              = module.vnet[each.value.vnet].get_subnet_id[each.value.subnet]
  ip_address          = each.value.ip_address
  public_ip           = try(module.pip[each.value.public_ip].get_pip_id,null)
  nsg_id              = module.NSG[each.value.nsg_id].get_nsg_id
  storage_account     = each.value.storage_account
  storage_account_rg  = each.value.storage_account_rg     
  size                = each.value.size
  os_disk_type        = each.value.os_disk_type
  os_profile          = local.os_profile.profile[each.value.subscription]
  data_disk           = each.value.data_disk
  tags                = each.value.tags

  depends_on = [module.RG]
}