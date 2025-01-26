# locals
locals {
  vm_id = var.Os_Type == "windows" ? {
    id = azurerm_windows_virtual_machine.vm_windows[0].id
    } : {
    id = azurerm_linux_virtual_machine.vm_linux[0].id
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
    public_ip_address_id          = var.public_ip
  }
}

# Winodws VM
resource "azurerm_windows_virtual_machine" "vm_windows" {
  count                     = var.Os_Type == "windows" ? 1:0

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
  count                           = var.Os_Type != "windows" ? 1:0

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

/*
# cse
resource "azurerm_virtual_machine_extension" "example" {
  name                 = "custom-script-extension"
  virtual_machine_id   = local.vm_id.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"

  settings = <<SETTINGS
  {
    "fileUris": ["https://rygussa.blob.core.windows.net/script/windows.ps1?"],
    "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File windows.ps1"
  }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "storageAccountName": "rygussa",
      "storageAccountKey": "Nj4h8TwOfCaHGPB4nN9kv8kbnyq9j/a8zKXHuvGeuWu7boYnz9qzjLY//iGHmPTuhhxIjJdVEBd2+AStS3MOdw=="
    }
  PROTECTED_SETTINGS

}
*/