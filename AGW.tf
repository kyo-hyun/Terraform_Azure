locals {
    AGW_List = {
        "skax-int-hub-agw" = {
            rg                      = "RG-KHKIM"
            location                = "koreacentral"
            identity_ids            = ["/subscriptions/122a2e7e-7d1a-4b2d-a26c-0a156dfa583c/resourceGroups/smjung-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mgid-koreacentral-smjung"]
            vnet                    = "vnet-khkim-hub"
            subnet                  = "agw-subnet"
            #public_ip               = "PIP-AGW"
            private_ip              = "10.0.0.173"

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

            # autoscale_configuration = {
            #   min_capacity = 1
            #   max_capacity = 15
            # }

            ssl_certificates = [
              {
                name                = "khkim-test"
                key_vault_secret_id = "https://kv-eastus-smjung.vault.azure.net/secrets/khkim-test/ec5233336b7c4887a55cfe3b786f0e1c"
                password            = "test123"
              }
            ]

            backend_address_pools = [
                {
                  name         = "backendpool-skax-aihub-apim"
                  ip_addresses = ["10.232.225.132"]
                }
            ]

            backend_http_settings = [
              {
                name                  = "backendsettings-01"
                cookie_based_affinity = "Disabled"
                path                  = "/"
                enable_https          = false
                request_timeout       = 20
              }
            ]

            http_listeners = [
              {
                name                 = "listener-aipmo-dev.skax.co.kr-http"
                frontend_ip_type     = "private"
                port                 = 80
              },
              {
                name                 = "listener-dpmo-minio-api.skax.co.kr-https"
                host_name            = "dpmo-minio-api.skax.co.kr"
                ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "private"
                port                 = 443
              }
            ]

            request_routing_rules = [
              {
                name                        = "routingrule-private-aihub.skax.co.kr-http"
                rule_type                   = "Basic"
                http_listener_name          = "listener-private-aihub.skax.co.kr-http"
                redirect_configuration_name = "private-aihub-http-to-https-redirect"
                priority                    = 120
              }
            ]

            redirect_configuration = [
              {
                name                  = "private-aihub-http-to-https-redirect"
                redirect_type         = "Permanent"
                include_path          = true
                include_query_string  = true
                target_listener_name  = "listener-private-aihub.skax.co.kr-https"
              }
            ]

            health_probes = [
              {
                name                  = "healthprobe-skax-aipmo"
                host                  = "aipmo-dev.skax.oc.kr"
                interval              = 60
                path                  = "/healthz"
                port                  = 80
                timeout               = 60
                unhealthy_threshold   = 3
                status_codes          = ["200-399"]
                backend_setting       = ["backendsettings-skax-aipmo-dev-http"]
              }
            ]

            #waf_policy_id = ""
            
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
    public_ip               = module.pip[each.value.public_ip].get_pip_id
    private_ip              = each.value.private_ip
    sku                     = each.value.sku
    identity_ids            = each.value.identity_ids
    ssl_certificates        = each.value.ssl_certificates
    request_routing_rules   = each.value.request_routing_rules
    http_listeners          = each.value.http_listeners
    health_probes           = each.value.health_probes
    autoscale_configuration = try(each.value.autoscale_configuration,null)
    redirect_configuration  = each.value.redirect_configuration
    waf_policy_id           = try(each.value.waf_policy_id,null)
}