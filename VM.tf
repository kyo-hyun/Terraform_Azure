locals {
  os_profile = yamldecode(file("./os_profile.yml"))

  # boot diagnostics storage account
  boot_storageaccount = {
    boot_diagsa         = "khkimtest"
    boot_diagsa_rg      = "khkim-test-rg"
  }

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

    # "vm-spoke" = {
    #   rg                  = "RG-KHKIM"
    #   location            = "koreacentral"
    #   vnet                = "vnet-spoke"
    #   subnet              = "vm-subnet"
    #   ip_address          = "12.0.0.5"
    #   public_ip           = "PIP-web1"
    #   nsg                 = "nsg-rygus-test"

    #   size                = "Standard_F2s_v2"
    #   os_disk_type        = "Standard_LRS"
    #   OsType              = "ubuntu"
    #   OsImage             = "22_04-lts"
    #   os_disk_size        = 32

    #   #script              = "set_apache.sh"

    #   data_disk           = {

    #   }
    #   tags = {
    #     owner = "김교현"
    #   }
    # }

    "vm-windows" = {
      rg                  = "RG-KHKIM"
      location            = "koreacentral"
      vnet                = "vnet-hub"
      subnet              = "vm-subnet"
      ip_address          = "11.0.0.69"
      public_ip           = "PIP-Hub"
      nsg                 = "nsg-rygus-test"

      size                = "Standard_F2s_v2"
      os_disk_type        = "Standard_LRS"
      OsType              = "Windows"
      OsImage             = "2019-datacenter"
      os_disk_size        = 128

      #script              = "set_apache.sh"

      data_disk           = {

      }

      tags = {
        owner = "김교현"
      }
    }

    # "windows-hub" = {
    #   rg                  = "RG-KHKIM"
    #   location            = "koreacentral"
    #   vnet                = "vnet-khkim-hub"
    #   subnet              = "backend-subnet"
    #   ip_address          = "10.0.0.165"
    #   public_ip           = "PIP-back1"
    #   nsg                 = "nsg-rygus-test"

    #   size                = "Standard_F2s_v2"
    #   os_disk_type        = "Standard_LRS"
    #   OsType              = "Windows"
    #   OsImage             = "2019-datacenter"
    #   os_disk_size        = 128

    #   #script              = "set_apache.sh"

    #   data_disk           = {

    #   }
    #   tags = {
    #     owner = "김교현"
    #   }
    # }

    # "KHKIM-DNAT" = {
    #   rg                  = "RG-KHKIM"
    #   location            = "koreacentral"
    #   vnet                = "vnet-khkim-hub"
    #   subnet              = "backend-subnet"
    #   ip_address          = "10.0.0.166"
    #   public_ip           = "PIP-NAT"
    #   nsg                 = "nsg-rygus-test"
    #   ip_forwarding       = true

    #   size                = "Standard_F2s_v2"
    #   os_disk_type        = "Standard_LRS"
    #   OsType              = "ubuntu"
    #   OsImage             = "22_04-lts"
    #   os_disk_size        = 32

    #   #script              = "set_apache.sh"

    #   data_disk           = {

    #   }
    #   tags = {
    #     owner = "김교현"
    #   }
    # }

    # "KHKIM-backend" = {
    #   rg                  = "RG-KHKIM"
    #   location            = "koreacentral"
    #   vnet                = "vnet-khkim-hub"
    #   subnet              = "backend-subnet"
    #   ip_address          = "10.0.0.165"
    #   #public_ip           = "PIP-back2"
    #   nsg                 = "nsg-rygus-test"

    #   size                = "Standard_F2s_v2"
    #   os_disk_type        = "Standard_LRS"
    #   OsType              = "ubuntu"
    #   OsImage             = "22_04-lts"
    #   os_disk_size        = 32

    #   #script              = "set_apache.sh"

    #   data_disk           = {

    #   }
    #   tags = {
    #     owner = "김교현"
    #   }
    # }

    # "windows-spoke" = {
    #   rg                  = "RG-KHKIM"
    #   location            = "koreacentral"
    #   vnet                = "vnet-khkim-spoke"
    #   subnet              = "test-vm-subnet"
    #   ip_address          = "12.0.4.101"
    #   public_ip           = "PIP-fw-pip"
    #   nsg                 = "nsg-rygus-test"

    #   size                = "Standard_F2s_v2"
    #   os_disk_type        = "Standard_LRS"
    #   OsType              = "Windows"
    #   OsImage             = "2019-datacenter"
    #   os_disk_size        = 128

    #   # script              = "set_apache.sh"

    #   data_disk           = {

    #   }
    #   tags = {
    #     owner = "김교현"
    #   }
    # }

    # "khkim-test" = {
    #   rg                  = "RG-KHKIM"
    #   location            = "koreacentral"
    #   vnet                = "vnet-khkim-hub"
    #   subnet              = "snet-hub1"
    #   ip_address          = "10.0.1.25"
    #   #public_ip           = "pip_nat"
    #   nsg                 = "nsg-rygus-test"

    #   size                = "Standard_F2s_v2"
    #   os_disk_type        = "Standard_LRS"
    #   OsType              = "ubuntu"
    #   OsImage             = "22_04-lts"
    #   os_disk_size        = 32

    #   #script              = "nat.sh"

    #   data_disk           = {

    #   }
    #   tags = {
    #     owner = "김교현"
    #   }
      
    # }

    # Windows VM
    # "khkim-Windows" = {
    #     rg                      = "RG-KHKIM-terraform"
    #     location                = "koreacentral"
    #     vnet                    = "vnet-rygus-test"
    #     subnet                  = "sub1"
    #     ip_address              = "10.0.1.24"
    #     public_ip               = "PIP_NEW_WIN"
    #     nsg                     = "nsg_terraform"

    #     size                    = "Standard_F2s_v2"
    #     os_disk_type            = "Standard_LRS"
    #     OsType                  = "Windows"
    #     OsImage                 = "2019-datacenter"
    #     os_disk_size            = 256

    #     data_disk = {
    #        1 = {
    #           size            = 32
    #           type            = "Standard_LRS"
    #        }
    #     }

    #     tags = {
    #         owner = "김교현",
    #         env   = "windows"
    #     }
    # }

    # Linux VM
    # "khkim-Linux" = {
    #   rg                  = "RG-KHKIM"
    #   location            = "koreacentral"
    #   vnet                = "vnet-rygus-test"
    #   subnet              = "sub1"
    #   ip_address          = "10.0.1.25"
    #   public_ip           = "PIP_NEW_LINUX"
    #   nsg                 = "nsg-rygus-test"

    #   size                = "Standard_F2s_v2"
    #   os_disk_type        = "Standard_LRS"
    #   OsType              = "ubuntu"
    #   OsImage             = "22_04-lts"
    #   os_disk_size        = 32

    #   script              = "disk_format."

    #   data_disk           = {
    #       2 = {
    #           size            = 64
    #           type            = "Standard_LRS"
    #        }
    #   }
    #   tags = {
    #     owner = "김교현",
    #     env   = "Terraform"
    #   }
      
    # }

    # 동일 리전 복제 VM 
    # "khkim-replica" = {
    #    VM_Type                  = "replica"
    #    rg                       = "RG-KHKIM-terraform"
    #    location                 = "koreacentral"
    #    vnet                     = "vnet-rygus-test"
    #    subnet                   = "sub2"
    #    ip_address               = "10.0.2.27"
    #    public_ip                = "PIP_replica"
    #    nsg                      = "nsg_terraform"
      
    #    size                     = "Standard_F4s_v2"
    #    os_disk_type             = "Standard_LRS"
    #    OsType                   = "Linux"
    #    os_disk_size             = 256
    #    source_snapshot          = "/subscriptions/122a2e7e-7d1a-4b2d-a26c-0a156dfa583c/resourceGroups/RG-KHKIM/providers/Microsoft.Compute/snapshots/linux-snap"

    #    data_disk = {
    #       1 = {
    #         size                = 64
    #         type                = "Standard_LRS"
    #         source_snapshot     = "/subscriptions/122a2e7e-7d1a-4b2d-a26c-0a156dfa583c/resourceGroups/RG-KHKIM/providers/Microsoft.Compute/snapshots/khkim-linux-datasnap"
    #       } 

    #       2 = {
    #         size                = 32
    #         type                = "Standard_LRS"
    #       } 
    #    }

    #    tags = {
    #      owner = "김교현",
    #      env   = "Terraform"
    #    }    
    # }

    # 리전 간 복제 VM
    # "khkim-region" = {
    #     VM_Type               = "replica"
    #     rg                    = "RG-KHKIM-terraform"
    #     location              = "koreacentral"
    #     vnet                  = "vnet-rygus-test"
    #     subnet                = "sub1"
    #     ip_address            = "10.0.1.27"
    #     public_ip             = "PIP_region_replica"
    #     nsg                   = "nsg_terraform"

    #     size                  = "Standard_F2s_v2"
    #     os_disk_type          = "Premium_LRS"
    #     OsType                = "Linux"
    #     os_disk_size          = 64
    #     source_vhd            = "https://khkimtest.blob.core.windows.net/vhd/OsSanp-khkim-jp-test-25-04-16.vhd"

    #     data_disk             = {
    #        1 = {
    #           size            = 64
    #           type            = "Standard_LRS"
    #           source_vhd      = "https://khkimtest.blob.core.windows.net/vhd/DataSanp-khkim-jp-test-25-04-16-0.vhd"
    #        }
    #     }

    #    tags = {
    #      owner = "김교현",
    #      env   = "replica"
    #    }
    # }

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
  osdisk_size        = each.value.os_disk_size
  sku                 = try(each.value.OsImage,null)
  subnet              = module.vnet[each.value.vnet].get_subnet_id[each.value.subnet]
  ip_address          = each.value.ip_address
  public_ip           = try(module.pip[each.value.public_ip].get_pip_id,null)
  nsg_id              = module.NSG[each.value.nsg].get_nsg_id
  storage_account     = local.boot_storageaccount.boot_diagsa
  storage_account_rg  = local.boot_storageaccount.boot_diagsa_rg
  ip_forwarding       = try(each.value.ip_forwarding, false)
  size                = each.value.size
  os_disk_type        = each.value.os_disk_type
  script              = try(each.value.script,null)
  source_snapshot     = try(each.value.source_snapshot,null)
  source_vhd          = try(each.value.source_vhd,null)
  os_profile          = local.os_profile.profile["nckr"]
  data_disk           = each.value.data_disk
  tags                = each.value.tags

  depends_on = [module.RG]
}