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

    # Windows VM
    # "khkim-Windows" = {

    #     subscription        = "nckr"
    #     rg                  = "RG-rygus-terraform"
    #     location            = "koreacentral"
    #     vnet                = "terraform_vnet"
    #     subnet              = "sub1"
    #     ip_address          = "10.0.1.24"
    #     public_ip           = "pip-khkim-replica"
    #     nsg_id              = "NSG1"
    #     storage_account     = "wemadestorageaccount"
    #     storage_account_rg  = "wemade-rg"

    #     size                = "Standard_F2s_v2"
    #     os_disk_type        = "Standard_LRS"
    #     OsType              = "windows"
    #     OsImage             = "2019-datacenter"

    #     data_disk           = {
    #       1 = {
    #         size            = 128
    #         type            = "Standard_LRS"
    #       }
    #     }

    #     tags = {
    #         owner = "김교현",
    #         env   = "windows"
    #     }

    # }

    # Linux VM
    # "khkim-1" = {
    #    subscription        = "nckr"
    #    rg                  = "RG-rygus-terraform"
    #    location            = "koreacentral"
    #    vnet                = "terraform_vnet"
    #    subnet              = "sub1"
    #    ip_address          = "10.0.1.25"
    #    public_ip           = null
    #    nsg_id              = "NSG2"
    #    storage_account     = "wemadestorageaccount"
    #    storage_account_rg  = "wemade-rg"

    #    size                = "Standard_F4s_v2"
    #    os_disk_type        = "Standard_LRS"
    #    OsType              = "ubuntu"
    #    OsImage             = "22_04-lts"

    #    data_disk           = {
    #       1 = {
    #         size            = 8
    #         type            = "Standard_LRS"
    #       }
    #    }

    #    tags = {
    #      owner = "김교현",
    #      env   = "Terraform"
    #    }
      
    # }

    # "khkim-2" = {
    #    subscription        = "nckr"
    #    rg                  = "RG-rygus-terraform"
    #    location            = "koreacentral"
    #    vnet                = "terraform_vnet"
    #    subnet              = "sub2"
    #    ip_address          = "10.0.2.27"
    #    public_ip           = null
    #    nsg_id              = "NSG2"
    #    storage_account     = "wemadestorageaccount"
    #    storage_account_rg  = "wemade-rg"

    #    size                = "Standard_F4s_v2"
    #    os_disk_type        = "Standard_LRS"
    #    OsType              = "ubuntu"
    #    OsImage             = "22_04-lts"

    #    data_disk           = {

    #    }

    #    tags = {
    #      owner = "김교현",
    #      env   = "Terraform"
    #    }
      
    # }

    # #Replica VM
    # "khkim-replica" = {
    #     subscription        = "nckr"
    #     rg                  = "RG-rygus-terraform"
    #     location            = "koreacentral"
    #     vnet                = "terraform_vnet"
    #     subnet              = "sub1"
    #     ip_address          = "10.0.1.27"
    #     public_ip           = "pip-khkim-replica"
    #     nsg_id              = "NSG1"
    #     storage_account     = "wemadestorageaccount"
    #     storage_account_rg  = "wemade-rg"

    #     size                = "Standard_F2s_v2"

    #     OsType              = "Linux"
    #     source_os_sanpshot  = "/subscriptions/122a2e7e-7d1a-4b2d-a26c-0a156dfa583c/resourceGroups/RG-rygus-terraform/providers/Microsoft.Compute/snapshots/OSDISK-rygus-snap"
    #     os_disk_type        = "Standard_LRS"

    #     data_disk           = {
          
    #     }

    #    tags = {
    #      owner = "김교현",
    #      env   = "replica"
    #    }
    # }

    # "khkim-ms" = {
    #    subscription        = "nckr"
    #    rg                  = "RG-rygus-terraform"
    #    location            = "koreacentral"
    #    vnet                = "terraform_vnet"
    #    subnet              = "sub2"
    #    ip_address          = "10.0.2.25"
    #    public_ip           = "PIP-KHKIM-MS"
    #    nsg_id              = "NSG-khkim"
    #    storage_account     = "wemadestorageaccount"
    #    storage_account_rg  = "wemade-rg"

    #    size                = "Standard_F2s_v2"
    #    os_disk_type        = "Standard_LRS"
    #    OsType              = "ubuntu"
    #    OsImage             = "22_04-lts"

    #    data_disk           = {

    #    }

    #    tags = {
    #      owner = "김교현"
    #    }
      
    # }

    # "khkim-work1" = {
    #    subscription        = "nckr"
    #    rg                  = "RG-rygus-terraform"
    #    location            = "koreacentral"
    #    vnet                = "terraform_vnet"
    #    subnet              = "sub2"
    #    ip_address          = "10.0.2.26"
    #    public_ip           = null
    #    nsg_id              = "NSG-khkim"
    #    storage_account     = "wemadestorageaccount"
    #    storage_account_rg  = "wemade-rg"

    #    size                = "Standard_F2s_v2"
    #    os_disk_type        = "Standard_LRS"
    #    OsType              = "ubuntu"
    #    OsImage             = "22_04-lts"

    #    data_disk           = {

    #    }

    #    tags = {
    #      owner = "김교현"
    #    }
      
    # }

    # "khkim-work2" = {
    #    subscription        = "nckr"
    #    rg                  = "RG-rygus-terraform"
    #    location            = "koreacentral"
    #    vnet                = "terraform_vnet"
    #    subnet              = "sub2"
    #    ip_address          = "10.0.2.27"
    #    public_ip           = null
    #    nsg_id              = "NSG-khkim"
    #    storage_account     = "wemadestorageaccount"
    #    storage_account_rg  = "wemade-rg"

    #    size                = "Standard_F2s_v2"
    #    os_disk_type        = "Standard_LRS"
    #    OsType              = "ubuntu"
    #    OsImage             = "22_04-lts"

    #    data_disk           = {

    #    }

    #    tags = {
    #      owner = "김교현"
    #    }
      
    # }

  }
}


module "azure_vm" {
  source              = "./module/VM"
  for_each            = local.vm_list
  name                = each.key
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
  source_os_snapshot  = try(each.value.source_os_sanpshot,null)
  os_profile          = local.os_profile.profile[each.value.subscription]
  data_disk           = each.value.data_disk
  tags                = each.value.tags

  depends_on = [module.RG]
}