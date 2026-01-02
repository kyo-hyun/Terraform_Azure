resource "azurerm_monitor_data_collection_rule" "aks_containerlogv2_multitenancy" {
  name                = var.name
  resource_group_name = var.rg
  location            = var.location
  kind                = "Linux"
  tags                = var.tags

  data_sources {
    extension {
      name           = "ContainerLogV2Extension"
      extension_name = "ContainerLogV2Extension"
      streams        = [
        "Microsoft-ContainerLogV2-HighScale"
      ]

      extension_json = jsonencode({
        dataCollectionSettings = {
          namespaces = var.namespaces
        }
      })
    }
  }

  destinations {
    log_analytics {
      name                  = "ciworkspace"
      workspace_resource_id = var.law_id
    }
  }

  data_flow {
    streams      = ["Microsoft-ContainerLogV2-HighScale"]
    destinations = ["ciworkspace"]
    transform_kql = (
      null
    )
  }
}

resource "azurerm_monitor_data_collection_rule_association" "aks_dcr_assoc" {
  name                    = "${var.name}-association"
  target_resource_id      = var.aks_id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.aks_containerlogv2_multitenancy.id
}
