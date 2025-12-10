resource "azurerm_application_gateway" "appgw" {
  name                = var.name
  resource_group_name = var.rg
  location            = var.location
  zones               = ["1","2","3"]
  enable_http2        = true

  ssl_policy {
    policy_type          = var.ssl_policy.policy_type
    min_protocol_version = var.ssl_policy.min_protocol_version
    cipher_suites        = var.ssl_policy.cipher_suites
  }

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
    name = "frontend_port_https"
    port = 443
  }

  frontend_port {
    name = "frontend_port_http"
    port = 80
  }

  # public Frontend IP Configuration
  dynamic "frontend_ip_configuration" {
    for_each = var.public_ip != null ? [1] : []
    content {
      name                 = "appGwPublicFrontendIpIPv4"
      public_ip_address_id = var.public_ip
    }
  }

  # Private Frontend IP Configuration
  dynamic "frontend_ip_configuration" {
    for_each = var.private_ip != null ? [1] : []
    content {
      name                          = "appGwPrivateFrontendIpIPv4"
      private_ip_address_allocation = "Static"
      private_ip_address            = var.private_ip
      subnet_id                     = var.subnet
    }
  }

  # Backend pools
  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools
    content {
      name         = backend_address_pool.value.name
      fqdns        = try(backend_address_pool.value.fqdns,null)
      ip_addresses = try(backend_address_pool.value.ip_addresses,null)
    }
  }

  # Backend settings
  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    content {
      name                   = backend_http_settings.value.name
      cookie_based_affinity  = lookup(backend_http_settings.value, "cookie_based_affinity", "Disabled")
      affinity_cookie_name   = lookup(backend_http_settings.value, "affinity_cookie_name", null)
      path                   = lookup(backend_http_settings.value, "path", "/")
      port                   = lookup(backend_http_settings.value, "port", "80")
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
      data                = lookup(ssl_certificate.value, "data", null)
    }
  }

  # Listener
  dynamic "http_listener" {
    for_each = var.listeners
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_type == "public" ? "appGwPublicFrontendIpIPv4" : "appGwPrivateFrontendIpIPv4"
      frontend_port_name             = http_listener.value.port == 80 ? "frontend_port_http" : "frontend_port_https"
      host_name                      = lookup(http_listener.value, "host_name", null)
      host_names                     = lookup(http_listener.value, "host_names", null)
      protocol                       = http_listener.value.port == 80 ? "Http" : "Https"
      ssl_certificate_name           = lookup(http_listener.value, "ssl_certificate_name", null)
    }
  }

  # Rules
  dynamic "request_routing_rule" {
    for_each = var.request_routing_rules
    content {
      name                        = request_routing_rule.value.name
      rule_type                   = lookup(request_routing_rule.value, "rule_type", "Basic")
      http_listener_name          = request_routing_rule.value.listener_name
      backend_address_pool_name   = lookup(request_routing_rule.value, "backend_address_pool_name",null)
      backend_http_settings_name  = lookup(request_routing_rule.value, "backend_http_settings_name",null)
      redirect_configuration_name = lookup(request_routing_rule.value, "redirect_configuration_name",null)
      priority                    = request_routing_rule.value.priority
    }
  }

  # Listener Redirect
  dynamic "redirect_configuration" {
    for_each = var.redirect_configuration
    content {
      name                 = redirect_configuration.value.name
      redirect_type        = redirect_configuration.value.redirect_type
      include_path         = redirect_configuration.value.include_path
      include_query_string = redirect_configuration.value.include_query_string
      target_listener_name = redirect_configuration.value.target_listener_name
    }
  }

  # Health probes
  dynamic "probe" {
    for_each = var.health_probes
    content {
      name                 = probe.value.name
      host                 = lookup(probe.value, "host", "127.0.0.1")
      interval             = lookup(probe.value, "interval", 30)
      protocol             = probe.value.port == 443 ? "Https" : "Http"
      path                 = lookup(probe.value, "path", "/")
      timeout              = lookup(probe.value, "timeout", 30)
      unhealthy_threshold  = lookup(probe.value, "unhealthy_threshold", 3)
      port                 = lookup(probe.value, "port", 443)
      match {
        status_code = lookup(probe.value, "status_codes", null)
      }
    }
  }

  # Managed ID
  dynamic "identity" {
    for_each = var.identity_ids != null ? [1] : []
    content {
      type         = "UserAssigned"
      identity_ids = var.identity_ids
    }
  }

  firewall_policy_id = var.waf_policy_id == null ? null : var.waf_policy_id
}