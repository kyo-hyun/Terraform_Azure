# locals
locals {
  vm_id = var.Os_Type == "windows" && var.source_os_snapshot == null ? {
    id = azurerm_windows_virtual_machine.vm_windows[0].id
    } : var.Os_Type != "windows" && var.source_os_snapshot == null ? {
    id = azurerm_linux_virtual_machine.vm_linux[0].id
    } : {
    id = azurerm_virtual_machine.replica_vm[0].id
    }
}

# get storage account 
data "azurerm_storage_account" "example" {
  name                = var.storage_account
  resource_group_name = var.storage_account_rg
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "NIC-${var.name}"
  location            = var.location
  resource_group_name = var.rg

  ip_configuration {
    name                          = "Ipconfiguration-${var.name}"
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ip_address
    public_ip_address_id          = var.public_ip == null ? null : var.public_ip
  }
}

# Winodws VM
resource "azurerm_windows_virtual_machine" "vm_windows" {
  count                     = var.Os_Type == "windows" && var.source_os_snapshot == null ? 1:0

  name                      = "${var.name}"
  resource_group_name       = var.rg
  location                  = var.location
  size                      = var.size
  admin_username            = var.os_profile.id
  admin_password            = var.os_profile.pw
  network_interface_ids     = [azurerm_network_interface.nic.id]
  timezone                  = "Korea Standard Time"

  enable_automatic_updates  = false
  patch_mode                = "Manual"

  boot_diagnostics {
      storage_account_uri = data.azurerm_storage_account.example.primary_blob_endpoint
  }

  os_disk {
    name                    = "OSDISK-${var.name}"
    caching                 = "ReadWrite"
    storage_account_type    = "Standard_LRS"
  }

  source_image_reference {
    publisher               = var.os_image.publisher
    offer                   = var.os_image.offer
    sku                     = var.sku
    version                 = "latest"
  }

  tags = var.tags
}

# Linux VM
resource "azurerm_linux_virtual_machine" "vm_linux" {
  count                           = var.Os_Type != "windows" && var.source_os_snapshot == null? 1:0

  name                            = "${var.name}"
  resource_group_name             = var.rg
  location                        = var.location
  size                            = var.size
  admin_username                  = var.os_profile.id
  admin_password                  = var.os_profile.pw
  network_interface_ids           = [azurerm_network_interface.nic.id]
  disable_password_authentication = false

  boot_diagnostics {
      storage_account_uri = data.azurerm_storage_account.example.primary_blob_endpoint
  }

  os_disk {
    name                    = "OSDISK-${var.name}"
    caching                 = "ReadWrite"
    storage_account_type    = var.os_disk_type
  }

  source_image_reference {
    publisher               = var.os_image.publisher
    offer                   = var.os_image.offer
    sku                     = var.sku
    version                 = "latest"
  }

  tags = var.tags
}

# data로 snapshot 불러오기
data "azurerm_snapshot" "os_disk_snapshot" {
  count               = var.source_os_snapshot != null ? 1 : 0
  name                = var.source_os_snapshot
  resource_group_name = "Test-FW-RG"
}

# replica osdisk 생성
resource "azurerm_managed_disk" "replica_os_disk" {
  count                 = var.source_os_snapshot != null ? 1 : 0
  name                 = "OSDISK-${var.name}"
  location             = var.location
  resource_group_name  = var.rg
  storage_account_type = var.os_disk_type
  create_option        = "Copy"
  source_resource_id   = data.azurerm_snapshot.os_disk_snapshot[0].id
}

# replica vm
resource "azurerm_virtual_machine" "replica_vm" {
  count                 = var.source_os_snapshot != null ? 1 : 0

  name                  = "${var.name}"
  location              = var.location
  resource_group_name   = var.rg
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = var.size

  delete_os_disk_on_termination = false
  delete_data_disks_on_termination = false

  storage_os_disk {
    name              = "OSDISK-${var.name}"
    caching           = "ReadWrite"
    create_option     = "Attach"
    managed_disk_id   = azurerm_managed_disk.replica_os_disk[0].id
    os_type           = var.Os_Type
  }

  tags = var.tags
}

# data disk 
resource "azurerm_managed_disk" "data_disk" {
  for_each              = var.data_disk
  name                  = "Datadisk${each.key}-${var.name}"
  location              = var.location
  resource_group_name   = var.rg
  storage_account_type  = each.value.type
  create_option         = "Empty"
  disk_size_gb          = each.value.size
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
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = var.nsg_id
}