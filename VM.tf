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

    # "khkim-windows" = {
    #   rg                  = "khkim_rg"
    #   location            = "koreacentral"
    #   vnet                = "spoke1-vnet"
    #   subnet              = "vm-snet1"
    #   ip_address          = "11.0.0.4"
    #   public_ip           = "PIP-worker1"
    #   nsg                 = "nsg-rygus-test"

    #   size                = "Standard_F4s_v2"
    #   os_disk_type        = "Standard_LRS"
    #   OsType              = "Windows"
    #   OsImage             = "2022-datacenter"
    #   os_disk_size        = 128

    #   automatic_updates   = true
    #   patch_mode          = "AutomaticByPlatform"

    #   # boot_diag_rg        = "khkim_rg"
    #   # boot_diag_stg       = "khkimstgtest123"

    #   # script              = "set_apache.sh"

    #   data_disk           = {

    #   }
    #   tags = {
    #     owner = "김교현"
    #   }
    # }

    # "khkim-ubuntu2" = {
    #   rg                  = "khkim_rg"
    #   location            = "koreacentral"
    #   vnet                = "spoke1-vnet"
    #   subnet              = "vm-snet2"
    #   ip_address          = "11.0.1.4"
    #   public_ip           = "PIP-worker2"
    #   nsg                 = "nsg-rygus-test"

    #   size                = "Standard_F4s_v2"
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

    "khkim-ubuntu1" = {
      rg                  = "khkim_rg"
      location            = "koreacentral"
      vnet                = "Hub-vnet"
      subnet              = "vm-subnet"
      ip_address          = "10.0.7.4"
      public_ip           = "PIP-worker1"
      nsg                 = "nsg-rygus-test"

      size                = "Standard_F4s_v2"
      os_disk_type        = "Standard_LRS"
      OsType              = "ubuntu"
      OsImage             = "22_04-lts"
      os_disk_size        = 32

      #script              = "set_apache.sh"

      data_disk           = {

      }
      tags = {
        owner = "김교현"
      }
    }

    # "khkim-ubuntu-2" = {
    #   rg                  = "khkim_rg"
    #   location            = "koreacentral"
    #   vnet                = "spoke1-vnet"
    #   subnet              = "vm-snet2"
    #   ip_address          = "11.0.1.4"
    #   public_ip           = "PIP-worker2"
    #   nsg                 = "nsg-rygus-test"

    #   size                = "Standard_F4s_v2"
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

    # "test-windows" = {
    #   rg                  = "khkim_rg"
    #   location            = "koreacentral"
    #   vnet                = "vnet-khkim"
    #   subnet              = "vm-subnet"
    #   ip_address          = "10.0.7.7"
    #   public_ip           = "PIP-LB"
    #   nsg                 = "nsg-rygus-test"

    #   size                = "Standard_F4s_v2"
    #   os_disk_type        = "Standard_LRS"
    #   OsType              = "Windows"
    #   OsImage             = "2019-datacenter"
    #   os_disk_size        = 128


    #   boot_diag_stg_rg    = "khkim_rg"
    #   boot_diag_stg       = "khkimstgtest123"

    #   cse_stg_rg          = "khkim_rg"
    #   cse_stg             = "csekhkim1234567"
    #   script              = "test.ps1"

    #   data_disk           = {

    #   }

    #   tags = {
    #     owner = "김교현"
    #   }
    # }

    # 동일 리전 복제 VM 
    # "khkim-replica" = {
    #    VM_Type                  = "replica"
    #    rg                       = "khkim_rg-terraform"
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
    #    source_snapshot          = "/subscriptions/122a2e7e-7d1a-4b2d-a26c-0a156dfa583c/resourceGroups/khkim_rg/providers/Microsoft.Compute/snapshots/linux-snap"

    #    data_disk = {
    #       1 = {
    #         size                = 64
    #         type                = "Standard_LRS"
    #         source_snapshot     = "/subscriptions/122a2e7e-7d1a-4b2d-a26c-0a156dfa583c/resourceGroups/khkim_rg/providers/Microsoft.Compute/snapshots/khkim-linux-datasnap"
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

    #리전 간 복제 VM
    # "khkim-region" = {
    #     VM_Type               = "replica"
    #     rg                    = "khkim_rg"
    #     location              = "koreacentral"
    #     vnet                  = "vnet-khkim"
    #     subnet                = "vm-subnet"
    #     ip_address            = "10.0.7.11"
    #     public_ip             = "PIP-worker2"
    #     nsg                   = "nsg-rygus-test"

    #     size                  = "Standard_F4s_v2"
    #     os_disk_type          = "Premium_LRS"
    #     OsType                = "Linux"
    #     os_disk_size          = 32

    #     boot_diag_stg_rg          = "khkim_rg"
    #     boot_diag_stg         = "khkimstgtest123"

    #     vhd_stg_rg            = "khkim_rg"
    #     vhd_stg               = "csekhkim1234567"
    #     source_vhd            = "https://csekhkim1234567.blob.core.windows.net/vhd/osdisk.vhd"

    #     data_disk             = {
    #        1 = {
    #           size            = 32
    #           type            = "Standard_LRS"
    #           source_vhd      = "https://csekhkim1234567.blob.core.windows.net/vhd/datadisk.vhd"
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