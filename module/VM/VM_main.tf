# locals
locals {
  vm_id = var.VM_Type == "new" && var.Os_Type == "Windows" ? {
    id = azurerm_windows_virtual_machine.vm_windows[0].id
    } : var.VM_Type == "new" && var.Os_Type != "Windows" ? {
    id = azurerm_linux_virtual_machine.vm_linux[0].id
    } : {
    id = azurerm_virtual_machine.replica_vm[0].id
    }
  nic_list = compact([
    azurerm_network_interface.primary_nic.id, 
    var.secondary_nic != null ? azurerm_network_interface.secondary_nic[0].id : ""
  ])
}

# Boot diagnostics storage account
data "azurerm_storage_account" "boot_stg" {
  count               = var.boot_diag_stg != null ? 1 : 0
  name                = var.boot_diag_stg
  resource_group_name = var.boot_diag_stg_rg
}

# Windows Custom Script Extension storage account
data "azurerm_storage_account" "cse_stg" {
  count               = var.cse_stg != null ? 1 : 0
  name                = var.cse_stg
  resource_group_name = var.cse_stg_rg
}

# Cross Region VM Replica (VHD)
data "azurerm_storage_account" "vhd_stg" {
  count               = var.vhd_stg != null ? 1 : 0
  name                = var.vhd_stg
  resource_group_name = var.vhd_stg_rg
}

# Primary Network Interface
resource "azurerm_network_interface" "primary_nic" {
  name                            = "NIC-${var.name}"
  location                        = var.location
  resource_group_name             = var.rg
  accelerated_networking_enabled  = true
  ip_forwarding_enabled           = var.ip_forwarding

  ip_configuration {
    name                          = "Ipconfiguration-${var.name}"
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ip_address
    public_ip_address_id          = var.public_ip == null ? null : var.public_ip
  }
}

# Secondary Network Interface
resource "azurerm_network_interface" "secondary_nic" {
  count                           = var.secondary_nic != null ? 1 : 0
  name                            = "NIC-secondary-${var.name}"
  location                        = var.location
  resource_group_name             = var.rg
  accelerated_networking_enabled  = true
  ip_forwarding_enabled           = true

  ip_configuration {
    name                          = "Ipconfiguration-secondary-${var.name}"
    subnet_id                     = var.secondary_nic.subnet
    private_ip_address_allocation = "Static"
    private_ip_address            = var.secondary_nic.ip_address
  }
}

# Winodws VM
resource "azurerm_windows_virtual_machine" "vm_windows" {
  count                             = var.Os_Type == "Windows" && var.VM_Type == "new" ? 1:0

  name                              = "${var.name}"
  resource_group_name               = var.rg
  location                          = var.location
  size                              = var.size
  admin_username                    = var.os_profile.id
  admin_password                    = var.os_profile.pw
  network_interface_ids             = local.nic_list
  timezone                          = "Korea Standard Time"

  automatic_updates_enabled         = var.automatic_updates
  patch_mode                        = var.patch_mode       

  dynamic "boot_diagnostics" {
    for_each = var.boot_diag_stg == null ? [] : [1]
    content {
      storage_account_uri = data.azurerm_storage_account.boot_stg[0].primary_blob_endpoint
    }
  }

  os_disk {
    name                    = "OSDISK-${var.name}"
    caching                 = "ReadWrite"
    storage_account_type    = "Standard_LRS"
    disk_size_gb            = var.osdisk_size
  }

  source_image_reference {
    publisher               = var.os_image.publisher
    offer                   = var.os_image.offer
    sku                     = var.sku
    version                 = "latest"
  }

  tags = var.tags
}

# windows vm cse
resource "azurerm_virtual_machine_extension" "cse" {
  count                 = var.Os_Type == "Windows" && var.script != null ? 1:0
  name                  = "custom-script-extension"
  virtual_machine_id    = azurerm_windows_virtual_machine.vm_windows[0].id
  publisher             = "Microsoft.Compute"
  type                  = "CustomScriptExtension"
  type_handler_version  = "1.10"

  settings = <<SETTINGS
    {
      "fileUris": ["https://${var.cse_stg}.blob.core.windows.net/script/${var.script}"],
      "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File ${var.script}"
    }
  SETTINGS

  protected_settings = jsonencode({
    storageAccountName = var.cse_stg
    storageAccountKey  = data.azurerm_storage_account.cse_stg[0].primary_access_key
  })

  lifecycle {
    ignore_changes = [
      settings,
      protected_settings
    ]
  }

  timeouts {
    create = "1h30m"
  }
}

# Linux VM
resource "azurerm_linux_virtual_machine" "vm_linux" {
  count                           = var.Os_Type != "Windows" && var.VM_Type == "new" ? 1:0

  name                            = "${var.name}"
  resource_group_name             = var.rg
  location                        = var.location
  size                            = var.size
  admin_username                  = var.os_profile.id
  admin_password                  = var.os_profile.pw
  network_interface_ids           = local.nic_list
  disable_password_authentication = false
  custom_data                     = var.script != null ? base64encode(file("${path.root}/script/${var.script}")) : null

  dynamic "boot_diagnostics" {
    for_each = var.boot_diag_stg == null ? [] : [1]
    content {
      storage_account_uri = data.azurerm_storage_account.boot_stg[0].primary_blob_endpoint
    }
  }

  os_disk {
    name                    = "OSDISK-${var.name}"
    caching                 = "ReadWrite"
    storage_account_type    = var.os_disk_type
    disk_size_gb            = var.osdisk_size
  }

  source_image_reference {
    publisher               = var.os_image.publisher
    offer                   = var.os_image.offer
    sku                     = var.sku
    version                 = "latest"
  }

  lifecycle {
    ignore_changes = [
      custom_data, identity
    ]
  }

  tags = var.tags
}

# replica osdisk 생성
resource "azurerm_managed_disk" "replica_os_disk" {
  count                             = var.VM_Type == "replica" ? 1 : 0
  name                              = "OSDISK-${var.name}"
  location                          = var.location
  resource_group_name               = var.rg
  storage_account_type              = var.os_disk_type
  create_option                     = var.source_vhd != null ? "Import" : "Copy"
  hyper_v_generation                = "V2"
  disk_size_gb                      = var.osdisk_size
  os_type                           = var.Os_Type

  # snapshot 복제 생성 (같은 리전 간 복제 생성)
  source_resource_id                = var.source_snapshot != null ? var.source_snapshot : null

  # vhd 복제 생성 (다른 리전 간 복제 생성)
  source_uri                        = var.source_vhd != null ? var.source_vhd : null
  storage_account_id                = var.source_vhd != null ? data.azurerm_storage_account.vhd_stg[0].id : null
}

# replica vm
resource "azurerm_virtual_machine" "replica_vm" {
  count                             = var.VM_Type == "replica" ? 1 : 0
  name                              = "${var.name}"
  location                          = var.location
  resource_group_name               = var.rg
  network_interface_ids             = local.nic_list
  vm_size                           = var.size
  delete_os_disk_on_termination     = false
  delete_data_disks_on_termination  = false

  storage_os_disk {
    name                            = "OSDISK-${var.name}"
    caching                         = "ReadWrite"
    create_option                   = "Attach"
    managed_disk_id                 = azurerm_managed_disk.replica_os_disk[0].id
    os_type                         = var.Os_Type
  }

  dynamic "boot_diagnostics" {
    for_each = var.boot_diag_stg == null ? [] : [1]
    content {
      enabled             = true
      storage_uri = data.azurerm_storage_account.boot_stg[0].primary_blob_endpoint
    }
  }

  tags = var.tags
}

resource "azurerm_managed_disk" "data_disk" {
  for_each              = var.data_disk
  name                  = "Datadisk${each.key}-${var.name}"
  location              = var.location
  resource_group_name   = var.rg
  storage_account_type  = each.value.type
  disk_size_gb          = each.value.size

  # snapshot이 null이면 empty 이런 개념이 안되는게 아예 snapshot자체가 선언이 되어 있지 않음
  create_option         = try(each.value.source_snapshot, null) != null ? "Copy" : try(each.value.source_vhd, null) != null ? "Import" : "Empty"

  # snapshot replica
  source_resource_id    = try(each.value.source_snapshot,null)

  # region replica
  source_uri            = try(each.value.source_vhd,null)
  storage_account_id    = try(each.value.source_vhd,null) != null ? data.azurerm_storage_account.vhd_stg[0].id : null
}

# attach data disk
resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  for_each              = var.data_disk
  managed_disk_id       = azurerm_managed_disk.data_disk[each.key].id
  virtual_machine_id    = local.vm_id.id
  lun                   = each.key
  caching               = "ReadOnly"
}

# attach nsg
resource "azurerm_network_interface_security_group_association" "nsg_attach" {
  count                     = var.nsg != null ? 1 : 0
  network_interface_id      = azurerm_network_interface.primary_nic.id
  network_security_group_id = var.nsg_id
}