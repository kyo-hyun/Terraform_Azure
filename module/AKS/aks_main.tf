resource "azurerm_user_assigned_identity" "aks" {
  name                = "uami-aks-dns"
  resource_group_name = var.resource_group
  location            = var.location
}

# aks cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                              = var.name
  location                          = var.location
  resource_group_name               = var.resource_group
  dns_prefix                        = var.dns_prefix
  kubernetes_version                = var.kube_version
  private_cluster_enabled           = var.private_cluster_enabled
  role_based_access_control_enabled = true
  node_os_upgrade_channel           = var.automatic_channel_upgrade
  private_dns_zone_id               = var.private_dns_zone_id
  oidc_issuer_enabled               = true
  workload_identity_enabled         = var.rbac == "azrbac" ? true : false

  # Azure RBAC를 사용한 Microsoft Entra ID 인증
  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.rbac == "azrbac" ? [1] : []
    content {
      tenant_id          = var.tenant_id
      azure_rbac_enabled = true
    }
  }

  dynamic "maintenance_window_auto_upgrade" {
    for_each = var.automatic_channel_upgrade == "SecurityPatch" ? [1] : []

    content {
      day_of_month = maintenance_window_auto_upgrade.value.day_of_month
      day_of_week  = maintenance_window_auto_upgrade.value.day_of_week
      duration     = maintenance_window_auto_upgrade.value.duration
      frequency    = maintenance_window_auto_upgrade.value.frequency
      interval     = maintenance_window_auto_upgrade.value.interval
      start_date   = maintenance_window_auto_upgrade.value.start_date
      start_time   = maintenance_window_auto_upgrade.value.start_time
      utc_offset   = maintenance_window_auto_upgrade.value.utc_offset
    }
  }
  
  default_node_pool {
    name                         = var.system_node_pool.node_pool_name
    vm_size                      = var.system_node_pool.vm_size       
    vnet_subnet_id               = var.subnet
    orchestrator_version         = var.kube_version
    auto_scaling_enabled         = var.system_node_pool.auto_scaling_enabled
    node_count                   = lookup(var.system_node_pool,"node_count",null)
    min_count                    = var.system_node_pool.auto_scaling_enabled == false ? null : var.system_node_pool.min_count
    max_count                    = var.system_node_pool.auto_scaling_enabled == false ? null : var.system_node_pool.max_count
    node_labels                  = lookup(var.system_node_pool,"node_labels", null)
    only_critical_addons_enabled = true

    upgrade_settings {
      max_surge = "10%"
      drain_timeout_in_minutes = 0
      node_soak_duration_in_minutes = 0
    }
  }

  # identity {
  #   type                  = var.managed_id != null ? "UserAssigned" : "SystemAssigned"
  #   identity_ids          = var.managed_id != null ? var.managed_id : null
  # }

  identity {
    type                  = "UserAssigned"
    identity_ids          = [azurerm_user_assigned_identity.aks.id]
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
  kubernetes_cluster_id     = azurerm_kubernetes_cluster.aks.id
  vm_size                   = each.value.vm_size
  node_count                = each.value.node_count
  orchestrator_version      = var.kube_version
  vnet_subnet_id            = var.subnet
  mode                      = each.value.mode
  os_type                   = each.value.os_type
  os_disk_size_gb           = each.value.os_disk_size_gb
  auto_scaling_enabled      = lookup(each.value,"auto_scaling_enabled",false)
  min_count                 = try(each.value.auto_scaling_enabled,false) == false ? null : var.system_node_pool.min_count
  max_count                 = try(each.value.auto_scaling_enabled,false) == false ? null : var.system_node_pool.max_count
  node_taints               = lookup(each.value,"node_taints",null)
  node_labels               = each.value.node_labels

  upgrade_settings {
      max_surge = "10%"
      drain_timeout_in_minutes = 0
      node_soak_duration_in_minutes = 0
  }
  tags = {
    Environment = "UserPool"
  }
}