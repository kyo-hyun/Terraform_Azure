locals {
  system_node_pool_key   = keys(var.system_node_pool)[0]
  system_node_pool_value = var.system_node_pool[local.system_node_pool_key]
}

resource "azurerm_kubernetes_cluster" "aks_test2" {
  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group
  dns_prefix                      = "aks-test-khkim"
        
  kubernetes_version              = var.kube_version
        
  private_cluster_enabled         = var.private_cluster_enabled

  default_node_pool {
    name                  = local.system_node_pool_key
    node_count            = local.system_node_pool_value.node_count
    vm_size               = local.system_node_pool_value.vm_size
    vnet_subnet_id        = var.subnet
    orchestrator_version  = var.kube_version
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin        = var.network_plugin     
    network_plugin_mode   = var.network_plugin_mode
    network_policy        = var.network_policy     
    service_cidr          = var.service_cidr       
    dns_service_ip        = var.dns_service_ip
    outbound_type         = var.outbound_type
  }

  linux_profile {
    admin_username = "azureuser"

    ssh_key {
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }

  tags = {
    Environment = "Test"
  }
}

# nodepool
resource "azurerm_kubernetes_cluster_node_pool" "userpool" {
  for_each                  = var.user_node_pool
  name                      = each.key
  kubernetes_cluster_id     = azurerm_kubernetes_cluster.aks_test2.id
  vm_size                   = each.value.vm_size
  node_count                = each.value.node_count
  orchestrator_version      = var.kube_version
  vnet_subnet_id            = var.subnet
  mode                      = each.value.mode
  os_type                   = each.value.os_type
  os_disk_size_gb           = each.value.os_disk_size_gb
  auto_scaling_enabled      = each.value.auto_scaling_enabled
  min_count                 = each.value.min_count
  max_count                 = each.value.max_count

  tags = {
    Environment = "UserPool"
  }
}