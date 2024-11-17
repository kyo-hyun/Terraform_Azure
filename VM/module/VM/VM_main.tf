resource "azurerm_network_interface" "main" {
  name                = "NIC-${var.name}"
  location            = var.location
  resource_group_name = var.rg

  ip_configuration {
    name                          = "Ipconfiguration-${var.name}"
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Static"
    private_ip_address            = var.ip_address
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.name}"
  location              = var.location
  resource_group_name   = var.rg
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.size

  storage_image_reference {
    publisher = var.os_image.publisher
    offer     = var.os_image.offer
    sku       = var.sku
    version   = "latest"
  }
  
  storage_os_disk {
    name              = "OSDISK-${var.name}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.name
    admin_username = var.os_profile.id
    admin_password = var.os_profile.pw
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  
  # os_profile_windows_config {
  #   provision_vm_agent        = true
  #   enable_automatic_upgrades = false
  # }

  tags = var.tags
}