# Azure Firewall
resource "azurerm_firewall" "firewall" {
  name                      = var.name
  location                  = var.location
  resource_group_name       = var.resource_group
  sku_name                  = "AZFW_VNet"
  sku_tier                  = var.sku
  threat_intel_mode         = "Alert"

  firewall_policy_id        = azurerm_firewall_policy.policy.id

  ip_configuration {
    name                    = "${var.name}-config"
    subnet_id               = var.subnet
    public_ip_address_id    = var.public_ip
  } 

  # management_ip_configuration {
  #   name                    = "${var.name}-mgmt-config"
  #   subnet_id               = var.mgmt_subnet
  #   public_ip_address_id    = var.mgmt_pip
  # }

  tags = {
    Environment = "Test"
  }
}

resource "azurerm_firewall_policy" "policy" {
  name                = "${var.name}-policy"
  location            = var.location
  resource_group_name = var.resource_group

  sku = var.sku
}

resource "azurerm_firewall_policy_rule_collection_group" "network" {
  name               = "DefaultNetworkRuleCollectionGroup"
  firewall_policy_id = azurerm_firewall_policy.policy.id
  priority           = 100

  dynamic "network_rule_collection" {
    for_each = var.network_collection
    content {
      name     = network_rule_collection.key
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.rule
        content {
          name                  = rule.key
          protocols             = rule.value.protocols
          source_addresses      = rule.value.source_addresses
          destination_addresses = rule.value.destination_addresses
          destination_ports     = rule.value.destination_ports
        }
      }
    }
  }
}