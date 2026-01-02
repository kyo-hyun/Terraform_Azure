locals {
    AGW_List = {
        # "agw" = {
        #     rg                      = "khkim_rg"
        #     location                = "koreacentral"
        #     #identity_ids            = [""]
        #     vnet                    = "Hub-vnet"
        #     subnet                  = "agw-subnet"
        #     public_ip               = "PIP-LB"
        #     private_ip              = "10.0.5.173"

        #     ssl_policy = {
        #       policy_type          = "CustomV2"
        #       min_protocol_version = "TLSv1_2"
        #       cipher_suites = [
        #         "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",
        #         "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384",
        #         "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256",
        #         "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
        #       ]
        #     }

        #     sku = {
        #         name     = "Standard_v2"
        #         tier     = "Standard_v2"
        #         capacity = 1
        #     }

        #     # autoscale_configuration = {
        #     #   min_capacity = 1
        #     #   max_capacity = 15
        #     # }

        #     ssl_certificates = [
        #     #   {
        #     #     name                = "khkim-test"
        #     #     key_vault_secret_id = null
        #     #     password            = "test123"
        #     #     data                = filebase64("./ssl/server.pfx")
        #     #   }
        #     ]

        #     backend_address_pools = [
        #         {
        #           name         = "backendpool-khkim"
        #           ip_addresses = ["10.0.7.4"]
        #         }
        #     ]

        #     backend_http_settings = [
        #       {
        #         name                  = "backendsettings-khkim"
        #         cookie_based_affinity = "Disabled"
        #         path                  = "/"
        #         port                  = 80
        #         enable_https          = false
        #         request_timeout       = 20
        #         probe_name            = "healthprobe-khkim"
        #       }
        #     ]

        #     listeners = [
        #       {
        #         name                 = "listener-khkim-http"
        #         frontend_ip_type     = "public"
        #         port                 = 80
        #       }
        #       # {
        #       #   name                 = "listener-khkim-https"
        #       #   host_name            = "www.khkim.com"
        #       #   ssl_certificate_name = "khkim-test"
        #       #   frontend_ip_type     = "private"
        #       #   port                 = 443
        #       # }
        #     ]

        #     request_routing_rules = [
        #       {
        #         name                        = "routingrule-khkim"
        #         rule_type                   = "Basic"
        #         listener_name               = "listener-khkim-http"
        #         backend_address_pool_name   = "backendpool-khkim"
        #         backend_http_settings_name  = "backendsettings-khkim"
        #         priority                    = 120
        #       }
        #     ]

        #     redirect_configuration = [

        #     ]

        #     health_probes = [
        #       {
        #         name                  = "healthprobe-khkim"
        #         #host                  = "www.khkim.com"
        #         interval              = 60
        #         path                  = "/sse"
        #         port                  = 3000
        #         timeout               = 60
        #         unhealthy_threshold   = 3
        #         status_codes          = ["200-399"]
        #         #backend_setting       = ["backendsettings-khkim"]
        #       }
        #     ]

        #     # waf_policy_id = ""
            
        # }
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