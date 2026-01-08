locals {
    AGW_List = {
        "hub-app-gw" = {
            rg                      = "Hub_rg"
            location                = "koreacentral"
            vnet                    = "hub-vnet"
            subnet                  = "agw-snet"
            public_ip               = "PIP-AGW"
            private_ip              = "10.0.0.4"

            ssl_policy = {
              policy_type          = "CustomV2"
              min_protocol_version = "TLSv1_2"
              cipher_suites = [
                "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",
                "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384",
                "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
                "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
              ]
            }

            sku = {
                name     = "Standard_v2"
                tier     = "Standard_v2"
                capacity = 1
            }

            ssl_certificates = [
              {
                name                = "spoke_ssl_cert"
                key_vault_secret_id = null
                password            = "password123"
                data                = filebase64("./ssl/spoke-web-auth.pfx")
              }
            ]

            backend_address_pools = [
                {
                  name         = "backendpool-spoke1"
                  ip_addresses = ["10.0.0.164"]
                },
                {
                  name         = "backendpool-spoke2"
                  ip_addresses = ["11.0.0.36"]
                }
            ]

            backend_http_settings = [
              {
                name                  = "backendsettings-spoke1"
                cookie_based_affinity = "Disabled"
                path                  = "/"
                port                  = 80
                enable_https          = false
                request_timeout       = 20
                probe_name            = "healthprobe-spoke1"
              },
              {
                name                  = "backendsettings-spoke2"
                cookie_based_affinity = "Disabled"
                path                  = "/"
                port                  = 80
                enable_https          = false
                request_timeout       = 20
                probe_name            = "healthprobe-spoke2"
              }
            ]

            listeners = [
              {
                name                 = "listener-spoke1-https"
                host_name            = "www.spoke1.com"
                ssl_certificate_name = "spoke_ssl_cert"
                frontend_ip_type     = "Public"
                port                 = 443
              },
              {
                name                 = "listener-spoke2-https"
                host_name            = "www.spoke2.com"
                ssl_certificate_name = "spoke_ssl_cert"
                frontend_ip_type     = "Public"
                port                 = 443
              }
            ]

            request_routing_rules = [
              {
                name                        = "routingrule-spoke1"
                rule_type                   = "Basic"
                listener_name               = "listener-spoke1-https"
                backend_address_pool_name   = "backendpool-spoke1"
                backend_http_settings_name  = "backendsettings-spoke1"
                priority                    = 100
              },
              {
                name                        = "routingrule-spoke2"
                rule_type                   = "Basic"
                listener_name               = "listener-spoke2-https"
                backend_address_pool_name   = "backendpool-spoke2"
                backend_http_settings_name  = "backendsettings-spoke2"
                priority                    = 200
              }
            ]

            redirect_configuration = [

            ]

            health_probes = [
              {
                name                  = "healthprobe-spoke1"
                host                  = "www.spoke1.com"
                interval              = 60
                path                  = "/"
                port                  = 80
                timeout               = 60
                unhealthy_threshold   = 3
                status_codes          = ["200"]
                backend_setting       = ["backendsettings-spoke1"]
              },
              {
                name                  = "healthprobe-spoke2"
                host                  = "www.spoke2.com"
                interval              = 60
                path                  = "/"
                port                  = 80
                timeout               = 60
                unhealthy_threshold   = 3
                status_codes          = ["200"]
                backend_setting       = ["backendsettings-spoke2"]
              }
            ]   
        }
    }
}

module "AGW" {
    source      = "./module/AGW"
    for_each    = local.AGW_List
    
    name                    = each.key
    rg                      = each.value.rg
    location                = each.value.location
    ssl_policy              = each.value.ssl_policy
    subnet                  = module.vnet[each.value.vnet].get_subnet_id[each.value.subnet]
    backend_address_pools   = each.value.backend_address_pools
    backend_http_settings   = each.value.backend_http_settings
    public_ip               = try(module.pip[each.value.public_ip].get_pip_id,null)
    private_ip              = each.value.private_ip
    sku                     = each.value.sku
    identity_ids            = try(each.value.identity_ids,null)
    ssl_certificates        = each.value.ssl_certificates
    request_routing_rules   = each.value.request_routing_rules
    listeners               = each.value.listeners
    health_probes           = each.value.health_probes
    autoscale_configuration = try(each.value.autoscale_configuration,null)
    redirect_configuration  = each.value.redirect_configuration
    waf_policy_id           = try(each.value.waf_policy_id,null)
}