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
      "2019-datacenter" = { publisher = "MicrosoftWindowsServer", offer = "WindowsServer" }
    }
  }

  vm_list = {

    # # Windows VM
    "khkim-Windows" = {
        VM_Type             = "new"
        subscription        = "nckr"
        rg                  = "RG-rygus-terraform"
        location            = "koreacentral"
        vnet                = "terraform_vnet"
        subnet              = "sub1"
        ip_address          = "10.0.1.24"
        public_ip           = "PIP_NEW_WIN"
        nsg_id              = "nsg_terraform"
        storage_account     = "wemadestorageaccount"
        storage_account_rg  = "wemade-rg"

        size                = "Standard_F2s_v2"
        os_disk_type        = "Standard_LRS"
        OsType              = "Windows"
        OsImage             = "2019-datacenter"

        data_disk           = {
          1 = {
           disk_type       = "new"
           size            = 32
           type            = "Standard_LRS"
          }
        }

        tags = {
            owner = "김교현",
            env   = "windows"
        }

    }

    # # Linux VM
    # "khkim-Linux" = {
    #   VM_Type             = "new"
    #   subscription        = "nckr"
    #   rg                  = "RG-rygus-terraform"
    #   location            = "koreacentral"
    #   vnet                = "terraform_vnet"
    #   subnet              = "sub1"
    #   ip_address          = "10.0.1.25"
    #   public_ip           = "PIP_NEW_LINUX"
    #   nsg_id              = "nsg_terraform"
    #   storage_account     = "wemadestorageaccount"
    #   storage_account_rg  = "wemade-rg"
    #   size                = "Standard_F2s_v2"
    #   os_disk_type        = "Standard_LRS"
    #   OsType              = "ubuntu"
    #   OsImage             = "22_04-lts"
    #   script              = "disk_format.sh"

    #   data_disk           = {
    #     1 = {
    #       disk_type       = "new"
    #       size            = 8
    #       type            = "Standard_LRS"
    #      }
    #   }
    #   tags = {
    #     owner = "김교현",
    #     env   = "Terraform"
    #   }
      
    # }

    # # 동일 리전 복제 VM 
    # "khkim-replica" = {
    #    VM_Type                  = "replica"
    #    subscription             = "nckr"
    #    rg                       = "RG-rygus-terraform"
    #    location                 = "koreacentral"
    #    vnet                     = "terraform_vnet"
    #    subnet                   = "sub2"
    #    ip_address               = "10.0.2.27"
    #    public_ip                = "PIP_replica"
    #    nsg_id                   = "nsg_terraform"
    #    storage_account          = "wemadestorageaccount"
    #    storage_account_rg       = "wemade-rg"
      
    #    size                     = "Standard_F2s_v2"
    #    OsType                   = "Linux"
    #    source_os_sanpshot       = "/subscriptions/122a2e7e-7d1a-4b2d-a26c-0a156dfa583c/resourceGroups/RG-KHKIM/providers/Microsoft.Compute/snapshots/OSDISK-SNAP-khkim"
    #    os_disk_type             = "Standard_LRS"

    #    data_disk = {
    #       1 = {
    #         disk_type           = "replica"
    #         type                = "Standard_LRS"
    #         source_resource_id  = "/subscriptions/122a2e7e-7d1a-4b2d-a26c-0a156dfa583c/resourceGroups/RG-KHKIM/providers/Microsoft.Compute/snapshots/DATA-SANP-khkim"
    #       }

    #       2 = {
    #         disk_type           = "new"
    #         size                = 8
    #         type                = "Standard_LRS"
    #       }
          
    #    }

    #    tags = {
    #      owner = "김교현",
    #      env   = "Terraform"
    #    }
      
    # }

    # # 리전 간 복제 VM
    # "khkim-region" = {
    #     VM_Type               = "region_replica"
    #     subscription          = "nckr"
    #     rg                    = "RG-rygus-terraform"
    #     location              = "koreacentral"
    #     vnet                  = "terraform_vnet"
    #     subnet                = "sub1"
    #     ip_address            = "10.0.1.27"
    #     public_ip             = "PIP_region_replica"
    #     nsg_id                = "nsg_terraform"
    #     storage_account       = "wemadestorageaccount"
    #     storage_account_rg    = "wemade-rg"

    #     size                  = "Standard_F2s_v2"

    #     OsType                = "Linux"
    #     os_disk_type          = "Standard_LRS"
    #     vhd_sa                = "https://wemadestorageaccount.blob.core.windows.net/vhd/OsSanp-khkim-jp-test-25-03-02.vhd"
    #     vhd_sa_id             = "/subscriptions/122a2e7e-7d1a-4b2d-a26c-0a156dfa583c/resourceGroups/wemade-rg/providers/Microsoft.Storage/storageAccounts/wemadestorageaccount"

    #     data_disk             = {
    #        1 = {
    #           disk_type       = "region_replica"
    #           type            = "Standard_LRS"
    #           data_vhd_sa     = "https://wemadestorageaccount.blob.core.windows.net/vhd/DataSanp-khkim-jp-test-25-03-02-0.vhd"
    #           data_vhd_sa_id  = "/subscriptions/122a2e7e-7d1a-4b2d-a26c-0a156dfa583c/resourceGroups/wemade-rg/providers/Microsoft.Storage/storageAccounts/wemadestorageaccount"
    #       }
    #     }

    #    tags = {
    #      owner = "김교현",
    #      env   = "replica"
    #    }
    # }

  }
}

module "azure_vm" {
  source              = "./module/VM"
  for_each            = local.vm_list
  name                = each.key
  VM_Type             = each.value.VM_Type
  rg                  = each.value.rg
  location            = each.value.location
  Os_Type             = each.value.OsType
  os_image            = try(local.image_map[each.value.OsType][each.value.OsImage],null)
  sku                 = try(each.value.OsImage,null)
  subnet              = module.vnet[each.value.vnet].get_subnet_id[each.value.subnet]
  ip_address          = each.value.ip_address
  public_ip           = try(module.pip[each.value.public_ip].get_pip_id,null)
  nsg_id              = module.NSG[each.value.nsg_id].get_nsg_id
  storage_account     = each.value.storage_account
  storage_account_rg  = each.value.storage_account_rg     
  size                = each.value.size
  os_disk_type        = each.value.os_disk_type
  script              = try(each.value.script,null)
  source_os_snapshot  = try(each.value.source_os_sanpshot,null)
  vhd_sa              = try(each.value.vhd_sa,null)
  vhd_sa_id           = try(each.value.vhd_sa_id,null)
  os_profile          = local.os_profile.profile[each.value.subscription]
  data_disk           = each.value.data_disk
  tags                = each.value.tags

  depends_on = [module.RG]
}