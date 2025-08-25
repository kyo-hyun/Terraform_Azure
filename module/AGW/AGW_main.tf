# resource "azurerm_web_application_firewall_policy" "waf_policy" {
#   name                = var.waf_policy_name
#   resource_group_name = var.rg
#   location            = var.location

#   policy_settings {
#     enabled            = true
#     mode               = "Prevention"
#     file_upload_limit_in_mb = 100
#     request_body_check = true
#     max_request_body_size_in_kb = 128
#   }

#     managed_rules {
#     managed_rule_set {
#       type    = "OWASP"
#       version = "3.1"
#     }
#   }

#   dynamic "custom_rule" {
#     for_each = var.custom_waf_rule_name != null ? [1] : []
#     content {
#       name     = var.custom_waf_rule_name
#       priority = var.custom_waf_rule_priority
#       rule_type = "MatchRule"
#       action   = var.custom_waf_rule_action

#       match_condition {
#         match_variables {
#           variable_name = "RemoteAddr"
#         }
#         operator     = "IPMatch"
#         negation_condition = false
#         match_values       = var.custom_waf_rule_ip_addresses
#       }
#     }
#   }
# }

resource "azurerm_application_gateway" "myagw" {
  name                = var.name
  resource_group_name = var.rg
  location            = var.location
  zones               = ["1","2","3"]

  sku {
    name     = var.sku.name
    tier     = var.sku.tier
    capacity = var.autoscale_configuration == null ? var.sku.capacity : null
  }

  dynamic "autoscale_configuration" {
    for_each = var.autoscale_configuration != null ? [var.autoscale_configuration] : []
    content {
      min_capacity = autoscale_configuration.value.min_capacity
      max_capacity = autoscale_configuration.value.max_capacity
    }
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = var.subnet
  }

  frontend_port {
    name = "frontend_port_name"
    port = 443
  }

  # public frontend
  frontend_ip_configuration {
    name                 = "appGwPublicFrontendIpIPv4"
    public_ip_address_id = var.public_ip
  }

  # private frontend
  dynamic "frontend_ip_configuration" {
    for_each = var.private_ip != null ? [1] : []
    content {
      name                         = "appGwPrivateFrontendIpIPv4"
      private_ip_address_allocation = "Static"
      private_ip_address            = var.private_ip
      subnet_id                    = var.subnet
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools
    content {
      name         = backend_address_pool.value.name
      fqdns        = try(backend_address_pool.value.fqdns,null)
      ip_addresses = try(backend_address_pool.value.ip_addresses,null)
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    content {
      name                   = backend_http_settings.value.name
      cookie_based_affinity  = lookup(backend_http_settings.value, "cookie_based_affinity", "Disabled")
      affinity_cookie_name   = lookup(backend_http_settings.value, "affinity_cookie_name", null)
      path                   = lookup(backend_http_settings.value, "path", "/")
      port                   = backend_http_settings.value.enable_https ? 443 : 80
      probe_name             = lookup(backend_http_settings.value, "probe_name", null)
      protocol               = backend_http_settings.value.enable_https ? "Https" : "Http"
      request_timeout        = lookup(backend_http_settings.value, "request_timeout", 30)
      host_name              = lookup(backend_http_settings.value, "host_name", null) != null ? backend_http_settings.value.host_name : null

      dynamic "authentication_certificate" {
        for_each = lookup(backend_http_settings.value,"authentication_certificate",null) != null ? [backend_http_settings.value.authentication_certificate] : []
        content {
          name = authentication_certificate.value.name
        }
      }

      trusted_root_certificate_names = lookup(backend_http_settings.value, "trusted_root_certificate_names", null)

      dynamic "connection_draining" {
        for_each = lookup(backend_http_settings.value, "connection_draining", null) != null ? [backend_http_settings.value.connection_draining] : []
        content {
          enabled           = connection_draining.value.enable_connection_draining
          drain_timeout_sec = connection_draining.value.drain_timeout_sec
        }
      }
    }
  }

  dynamic "ssl_certificate" {
    for_each = var.ssl_certificates
    content {
      name                = ssl_certificate.value.name
      password            = ssl_certificate.value.key_vault_secret_id == null ? ssl_certificate.value.password : null
      key_vault_secret_id = lookup(ssl_certificate.value, "key_vault_secret_id", null)
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listeners
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = "appGwPublicFrontendIpIPv4"
      frontend_port_name             = "frontend_port_name"
      host_name                      = lookup(http_listener.value, "host_name", null)
      host_names                     = lookup(http_listener.value, "host_names", null)
      protocol                       = http_listener.value.ssl_certificate_name == null ? "Http" : "Https"
      ssl_certificate_name           = http_listener.value.ssl_certificate_name
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rules
    content {
      name                        = request_routing_rule.value.name
      rule_type                   = lookup(request_routing_rule.value, "rule_type", "Basic")
      http_listener_name          = request_routing_rule.value.http_listener_name
      backend_address_pool_name   = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name  = request_routing_rule.value.backend_http_settings_name
      priority                    = request_routing_rule.value.priority
    }
  }

  dynamic "probe" {
    for_each = var.health_probes
    content {
      name                                      = probe.value.name
      host                                      = lookup(probe.value, "host", "127.0.0.1")
      interval                                  = lookup(probe.value, "interval", 30)
      protocol                                  = probe.value.port == 443 ? "Https" : "Http"
      path                                      = lookup(probe.value, "path", "/")
      timeout                                   = lookup(probe.value, "timeout", 30)
      unhealthy_threshold                       = lookup(probe.value, "unhealthy_threshold", 3)
      port                                      = lookup(probe.value, "port", 443)
      #pick_host_name_from_backend_http_settings = lookup(probe.value, "pick_host_name_from_backend_http_settings", false)
      #minimum_servers                           = lookup(probe.value, "minimum_servers", 0)
    }
  }

  dynamic "identity" {
    for_each = var.identity_ids != null ? [1] : []
    content {
      type         = "UserAssigned"
      identity_ids = var.identity_ids
    }
  }

  firewall_policy_id = var.waf_policy_id
  }