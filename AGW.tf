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
                },
                {
                  name         = "backendpool-skax-talentx-dev"
                  ip_addresses = ["10.232.232.84"]
                },
                {
                  name         = "backendpool-skax-aihub-apim-https"
                  ip_addresses = ["10.232.225.132"]
                },
                {
                  name         = "backendpool-private-skax-talentx-dev"
                  ip_addresses = ["10.232.232.84"]
                },
                {
                  name         = "backendpool-skax-talentx-prod"
                  ip_addresses = ["10.232.232.212"]
                },
                {
                  name         = "backendpool-skax-agshub-dev"
                  ip_addresses = ["10.232.231.84"]
                },
                {
                  name         = "backendpool-skax-agshub-prod"
                  ip_addresses = ["10.232.231.212"]
                },
                {
                  name         = "backendpool-private-skax-aipmo-dev"
                  ip_addresses = ["10.232.226.42"]
                },
                {
                  name         = "backendpool-private-skax-dpmo-prd"
                  ip_addresses = ["10.232.226.133"]
                },
                {
                  name         = "backendpool-private-skax-aipmo-prd"
                  ip_addresses = ["10.232.226.133"]
                },
            ]

            backend_http_settings = [
              {
                name                  = "backendsettings-01"
                cookie_based_affinity = "Disabled"
                path                  = "/"
                enable_https          = false
                request_timeout       = 20
              },
              {
                name                  = "backendsettings-skax-aihub-apim"
                cookie_based_affinity = "Disabled"
                path                  = "/"
                enable_https          = false
                request_timeout       = 20
                host_name             = "aihub.skax.co.kr"
                probe_name            = "healthprobe-skax-aihub-apim"
              },
              {
                name                  = "backendsettings-skax-aihub-apim-https"
                cookie_based_affinity = "Disabled"
                path                  = "/"
                enable_https          = true
                request_timeout       = 300
                host_name             = "aihub.skax.co.kr"
                probe_name            = "healthprobe-skax-aihub-apim-https"
              },
              {
                name                  = "backendsettings-skax-talentx-dev"
                cookie_based_affinity = "Disabled"
                path                  = "/"
                enable_https          = false
                request_timeout       = 20
                host_name             = "talentax-dev.skax.co.kr"
                probe_name            = "healthprobe-skax-talentx-dev"
              },
              {
                name                  = "backendsettings-private-skax-talentx-dev"
                cookie_based_affinity = "Disabled"
                path                  = "/"
                enable_https          = false
                request_timeout       = 20
                host_name             = "talentax-dev.skax.co.kr"
              },
              {
                name                  = "backendsettings-skax-talentx-prod"
                cookie_based_affinity = "Disabled"
                path                  = "/"
                enable_https          = false
                request_timeout       = 20
                host_name             = "talentax.skax.co.kr"
                probe_name            = "healthprobe-skax-talentx-prod"
              },
              {
                name                  = "backendsettings-skax-agshub-dev-http"
                cookie_based_affinity = "Disabled"
                path                  = "/"
                enable_https          = false
                request_timeout       = 20
                host_name             = "agshub-dev.skax.co.kr"
                probe_name            = "healthprobe-agshub-dev"
              },
              {
                name                  = "backendsettings-skax-agshub-prod-http"
                cookie_based_affinity = "Disabled"
                path                  = "/"
                enable_https          = false
                request_timeout       = 20
                host_name             = "agshub.skax.co.kr"
                probe_name            = "healthprobe-agshub-prod"
              },
              {
                name                  = "backendsettings-skax-dpmo-prod-http"
                cookie_based_affinity = "Disabled"
                path                  = "/"
                enable_https          = false
                request_timeout       = 300
                host_name             = "dpmo.skax.co.kr"
                probe_name            = "healthprobe-skax-dpmo"
              },
              {
                name                  = "backendsettings-skax-aipmo-prod-http"
                cookie_based_affinity = "Disabled"
                path                  = "/"
                enable_https          = false
                request_timeout       = 300
                host_name             = "aipmo.skax.co.kr"
              },
              {
                name                  = "backendsettings-skax-aipmo-dev-http"
                cookie_based_affinity = "Disabled"
                path                  = "/"
                enable_https          = false
                request_timeout       = 300
                host_name             = "aipmo-dev.skax.co.kr"
                probe_name            = "healthprobe-skax-aipmo"
              },
              {
                name                  = "backendsettings-skax-dpmo-works-prod-http"
                cookie_based_affinity = "Disabled"
                path                  = "/"
                enable_https          = false
                request_timeout       = 300
                host_name             = "dpmo-works.skax.co.kr"
                probe_name            = "healthprobe-skax-dpmo"
              },
              {
                name                  = "backendsettings-skax-dpmo-console-prod-http"
                cookie_based_affinity = "Disabled"
                path                  = "/"
                enable_https          = false
                request_timeout       = 30
                host_name             = "dpmo-console.skax.co.kr"
                probe_name            = "healthprobe-skax-dpmo"
              },
            ]

            http_listeners = [
              {
                name                 = "listener-aipmo-dev.skax.co.kr-http"
                #ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "private"
                port                 = 80
              },
              {
                name                 = "listener-dpmo-minio-api.skax.co.kr-https"
                host_name            = "dpmo-minio-api.skax.co.kr"
                ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "private"
                port                 = 443
              },
              {
                name                 = "listener-dpmo-minio.skax.co.kr-https"
                host_name            = "dpmo-minio.skax.co.kr"
                ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "private"
                port                 = 443
              },
              {
                name                 = "listener-dpmo-harbor.skax.co.kr-https"
                host_name            = "dpmo-harbor.skax.co.kr"
                ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "private"
                port                 = 443
              },
              {
                name                 = "listener-dpmo-argocd.skax.co.kr-https"
                host_name            = "dpmo-argocd.skax.co.kr"
                ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "private"
                port                 = 443
              },
              {
                name                 = "listener-dpmo-console.skax.co.kr-https"
                host_name            = "dpmo-console.skax.co.kr"
                ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "private"
                port                 = 443
              },
              {
                name                 = "listener-dpmo-works.skax.co.kr-https"
                host_name            = "dpmo-works.skax.co.kr"
                ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "private"
                port                 = 443
              },
              {
                name                 = "listener-dpmo.skax.co.kr-https"
                host_name            = "dpmo.skax.co.kr"
                ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "private"
                port                 = 443
              },
              {
                name                 = "listener-aipmo-dev.skax.co.kr-https"
                host_name            = "aipmo-dev.skax.co.kr"
                ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "private"
                port                 = 443
              },
              {
                name                 = "listener-agshub.skax.co.kr-https"
                host_name            = "agshub.skax.co.kr"
                ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "public"
                port                 = 443
              },
              {
                name                 = "listener-private-agshub.skax.co.kr-https"
                host_name            = "agshub.skax.co.kr"
                ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "private"
                port                 = 443
              },
              {
                name                 = "listener-private-agshub.skax.co.kr-http"
                host_name            = "agshub.skax.co.kr"
                #ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "private"
                port                 = 80
              },
              {
                name                 = "listener-agshub.skax.co.kr-http"
                host_name            = "agshub.skax.co.kr"
                #ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "public"
                port                 = 80
              },
              {
                name                 = "listener-private-agshub-dev.skax.co.kr-https"
                host_name            = "agshub-dev.skax.co.kr"
                ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "private"
                port                 = 443
              },
              {
                name                 = "listener-private-agshub-dev.skax.co.kr-http"
                host_name            = "agshub-dev.skax.co.kr"
                #ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "private"
                port                 = 80
              },
              {
                name                 = "listener-agshub-dev.skax.co.kr-https"
                host_name            = "agshub-dev.skax.co.kr"
                ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "public"
                port                 = 443
              },
              {
                name                 = "listener-agshub-dev.skax.co.kr-http"
                host_name            = "agshub-dev.skax.co.kr"
                #ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "public"
                port                 = 80
              },
              {
                name                 = "listener-private-talentx.skax.co.kr-https"
                host_name            = "talentax.skax.co.kr"
                ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "private"
                port                 = 443
              },
              {
                name                 = "listener-private-talentx.skax.co.kr-http"
                host_name            = "talentax.skax.co.kr"
                #ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "private"
                port                 = 80
              },
              {
                name                 = "listener-talentax.skax.co.kr-https"
                host_name            = "talentax.skax.co.kr"
                ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "public"
                port                 = 443
              },
              {
                name                 = "listener-talentax.skax.co.kr-http"
                host_name            = "talentax.skax.co.kr"
                #ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "public"
                port                 = 80
              },
              {
                name                 = "listener-talentx-dev.skax.co.kr-https"
                host_name            = "talentax-dev.skax.co.kr"
                ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "public"
                port                 = 443
              },
              {
                name                 = "listener-talentx-dev.skax.co.kr-http"
                host_name            = "talentax-dev.skax.co.kr"
                #ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "public"
                port                 = 80
              },
              {
                name                 = "listener-private-talentx-dev.skax.co.kr-https"
                host_name            = "talentax-dev.skax.co.kr"
                ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "private"
                port                 = 443
              },
              {
                name                 = "listener-private-talentx-dev.skax.co.kr-http"
                host_name            = "talentax-dev.skax.co.kr"
                #ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "private"
                port                 = 80
              },
              {
                name                 = "listener-private-aihub.skax.co.kr-https"
                host_name            = "aihub.skax.co.kr"
                ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "private"
                port                 = 443
              },
              {
                name                 = "listener-private-aihub.skax.co.kr-http"
                host_name            = "aihub.skax.co.kr"
                #ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "private"
                port                 = 80
              },
              {
                name                 = "listener-aihub.skax.co.kr-http"
                host_name            = "aihub.skax.co.kr"
                #ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "public"
                port                 = 80
              },
              {
                name                 = "listener-aihub.skax.co.kr-https"
                host_name            = "aihub.skax.co.kr"
                ssl_certificate_name = "khkim-test"
                frontend_ip_type     = "public"
                port                 = 443
              },
            ]

            request_routing_rules = [
              {
                name                        = "routingrule-private-aihub.skax.co.kr-http"
                rule_type                   = "Basic"
                http_listener_name          = "listener-private-aihub.skax.co.kr-http"
                redirect_configuration_name = "private-aihub-http-to-https-redirect"
                priority                    = 120
              },
              {
                name                        = "routingrule-private-aihub.skax.co.kr-https"
                rule_type                   = "Basic"
                http_listener_name          = "listener-private-aihub.skax.co.kr-https"
                backend_address_pool_name   = "backendpool-skax-aihub-apim-https"
                backend_http_settings_name  = "backendsettings-skax-aihub-apim-https"
                priority                    = 121
              },
              {
                name                        = "routingrule-private-talentx-dev.skax.co.kr-http"
                rule_type                   = "Basic"
                http_listener_name          = "listener-private-talentx-dev.skax.co.kr-http"
                redirect_configuration_name = "private-talentx-http-to-https-redirect"
                priority                    = 150
              },
              {
                name                        = "routingrule-private-talentx-dev.skax.co.kr-https"
                rule_type                   = "Basic"
                http_listener_name          = "listener-private-talentx-dev.skax.co.kr-https"
                backend_address_pool_name   = "backendpool-private-skax-talentx-dev"
                backend_http_settings_name  = "backendsettings-private-skax-talentx-dev"
                priority                    = 160
              },
              {
                name                        = "routingrule-talentx.skax.co.kr-http"
                rule_type                   = "Basic"
                http_listener_name          = "listener-talentax.skax.co.kr-http"
                backend_address_pool_name   = "backendpool-skax-talentx-prod"
                backend_http_settings_name  = "backendsettings-skax-talentx-prod"
                priority                    = 161
              },
              {
                name                        = "routingrule-talentx.skax.co.kr-https"
                rule_type                   = "Basic"
                http_listener_name          = "listener-talentax.skax.co.kr-https"
                backend_address_pool_name   = "backendpool-skax-talentx-prod"
                backend_http_settings_name  = "backendsettings-skax-talentx-prod"
                priority                    = 162
              },
              {
                name                        = "routingrule-private-talentx.skax.co.kr-http"
                rule_type                   = "Basic"
                http_listener_name          = "listener-private-talentx.skax.co.kr-http"
                backend_address_pool_name   = "backendpool-skax-talentx-prod"
                backend_http_settings_name  = "backendsettings-skax-talentx-prod"
                priority                    = 163
              },
              {
                name                        = "routingrule-private-talentx.skax.co.kr-https"
                rule_type                   = "Basic"
                http_listener_name          = "listener-private-talentx.skax.co.kr-https"
                backend_address_pool_name   = "backendpool-skax-talentx-prod"
                backend_http_settings_name  = "backendsettings-skax-talentx-prod"
                priority                    = 164
              },
              {
                name                        = "routingrule-agshub-dev.skax.co.kr-http"
                rule_type                   = "Basic"
                http_listener_name          = "listener-agshub-dev.skax.co.kr-http"
                backend_address_pool_name   = "backendpool-skax-agshub-dev"
                backend_http_settings_name  = "backendsettings-skax-agshub-dev-http"
                priority                    = 170
              },
              {
                name                        = "routingrule-agshub-dev.skax.co.kr-https"
                rule_type                   = "Basic"
                http_listener_name          = "listener-agshub-dev.skax.co.kr-https"
                backend_address_pool_name   = "backendpool-skax-agshub-dev"
                backend_http_settings_name  = "backendsettings-skax-agshub-dev-http"
                priority                    = 171
              },
              {
                name                        = "routingrule-private-agshub-dev.skax.co.kr-http"
                rule_type                   = "Basic"
                http_listener_name          = "listener-private-agshub-dev.skax.co.kr-http"
                backend_address_pool_name   = "backendpool-skax-agshub-dev"
                backend_http_settings_name  = "backendsettings-skax-agshub-dev-http"
                priority                    = 172
              },
              {
                name                        = "routingrule-private-agshub-dev.skax.co.kr-https"
                rule_type                   = "Basic"
                http_listener_name          = "listener-private-agshub-dev.skax.co.kr-https"
                backend_address_pool_name   = "backendpool-skax-agshub-dev"
                backend_http_settings_name  = "backendsettings-skax-dpmo-console-prod-http"
                priority                    = 173
              },
              {
                name                        = "routingrule-agshub.skax.co.kr-http"
                rule_type                   = "Basic"
                http_listener_name          = "listener-agshub.skax.co.kr-http"
                backend_address_pool_name   = "backendpool-skax-agshub-prod"
                backend_http_settings_name  = "backendsettings-skax-agshub-prod-http"
                priority                    = 174
              },
              {
                name                        = "routingrule-agshub.skax.co.kr-https"
                rule_type                   = "Basic"
                http_listener_name          = "listener-agshub.skax.co.kr-https"
                backend_address_pool_name   = "backendpool-skax-agshub-prod"
                backend_http_settings_name  = "backendsettings-skax-agshub-prod-http"
                priority                    = 175
              },
              {
                name                        = "routingrule-private-agshub.skax.co.kr-http"
                rule_type                   = "Basic"
                http_listener_name          = "listener-private-agshub.skax.co.kr-http"
                backend_address_pool_name   = "backendpool-skax-agshub-prod"
                backend_http_settings_name  = "backendsettings-skax-agshub-prod-http"
                priority                    = 176
              },
              {
                name                        = "routingrule-private-agshub.skax.co.kr-https"
                rule_type                   = "Basic"
                http_listener_name          = "listener-private-agshub.skax.co.kr-https"
                backend_address_pool_name   = "backendpool-skax-agshub-prod"
                backend_http_settings_name  = "backendsettings-skax-agshub-prod-http"
                priority                    = 177
              },
              {
                name                        = "routingrule-aihub.skax.co.kr-http"
                rule_type                   = "Basic"
                http_listener_name          = "listener-aihub.skax.co.kr-http"
                redirect_configuration_name = "public-aihub-http-to-https-redirect"
                priority                    = 200
              },
              {
                name                        = "routingrule-aihub.skax.co.kr-https"
                rule_type                   = "Basic"
                http_listener_name          = "listener-aihub.skax.co.kr-https"
                backend_address_pool_name   = "backendpool-skax-aihub-apim-https"
                backend_http_settings_name  = "backendsettings-skax-aihub-apim-https"
                priority                    = 220
              },
              {
                name                        = "routingrule-talentx-dev.skax.co.kr-http"
                rule_type                   = "Basic"
                http_listener_name          = "listener-talentx-dev.skax.co.kr-http"
                redirect_configuration_name = "talentx-dev-http-to-https-redirect"
                priority                    = 300
              },
              {
                name                        = "routingrule-talentx-dev.skax.co.kr-https"
                rule_type                   = "Basic"
                http_listener_name          = "listener-talentx-dev.skax.co.kr-https"
                backend_address_pool_name   = "backendpool-skax-talentx-dev"
                backend_http_settings_name  = "backendsettings-skax-talentx-dev"
                priority                    = 350
              },
              {
                name                        = "routingrule-private-dpmo.skax.co.kr-https"
                rule_type                   = "Basic"
                http_listener_name          = "listener-dpmo.skax.co.kr-https"
                backend_address_pool_name   = "backendpool-private-skax-dpmo-prd"
                backend_http_settings_name  = "backendsettings-skax-dpmo-prod-http"
                priority                    = 400
              },
              {
                name                        = "routingrule-private-aipmo-dev.skax.co.kr-http"
                rule_type                   = "Basic"
                http_listener_name          = "listener-aipmo-dev.skax.co.kr-https"
                backend_address_pool_name   = "backendpool-private-skax-aipmo-dev"
                backend_http_settings_name  = "backendsettings-skax-aipmo-dev-http"
                priority                    = 410
              },
              {
                name                        = "routingrule-private-aipmo-dev.skax.co.kr-http80"
                rule_type                   = "Basic"
                http_listener_name          = "listener-aipmo-dev.skax.co.kr-http"
                redirect_configuration_name = "private-dev-aipmo-http-to-https"
                priority                    = 411
              },
              {
                name                        = "routingrule-private-dpmo-minio-api.skax.co.kr-https"
                rule_type                   = "Basic"
                http_listener_name          = "listener-dpmo-minio-api.skax.co.kr-https"
                backend_address_pool_name   = "backendpool-private-skax-dpmo-prd"
                backend_http_settings_name  = "backendsettings-skax-dpmo-prod-http"
                priority                    = 420
              },
              {
                name                        = "routingrule-private-dpmo-minio.skax.co.kr-https"
                rule_type                   = "Basic"
                http_listener_name          = "listener-dpmo-minio.skax.co.kr-https"
                backend_address_pool_name   = "backendpool-private-skax-dpmo-prd"
                backend_http_settings_name  = "backendsettings-skax-dpmo-prod-http"
                priority                    = 430
              },
              {
                name                        = "routingrule-private-dpmo-harbor.skax.co.kr-https"
                rule_type                   = "Basic"
                http_listener_name          = "listener-dpmo-harbor.skax.co.kr-https"
                backend_address_pool_name   = "backendpool-private-skax-dpmo-prd"
                backend_http_settings_name  = "backendsettings-skax-dpmo-prod-http"
                priority                    = 440
              },
              {
                name                        = "routingrule-private-dpmo-argocd.skax.co.kr-https"
                rule_type                   = "Basic"
                http_listener_name          = "listener-dpmo-argocd.skax.co.kr-https"
                backend_address_pool_name   = "backendpool-private-skax-dpmo-prd"
                backend_http_settings_name  = "backendsettings-skax-dpmo-prod-http"
                priority                    = 450
              },
              {
                name                        = "routingrule-private-dpmo-console.skax.co.kr-https"
                rule_type                   = "Basic"
                http_listener_name          = "listener-dpmo-console.skax.co.kr-https"
                backend_address_pool_name   = "backendpool-private-skax-dpmo-prd"
                backend_http_settings_name  = "backendsettings-skax-dpmo-console-prod-http"
                priority                    = 460
              },
              {
                name                        = "routingrule-private-dpmo-works.skax.co.kr-https"
                rule_type                   = "Basic"
                http_listener_name          = "listener-dpmo-works.skax.co.kr-https"
                backend_address_pool_name   = "backendpool-private-skax-dpmo-prd"
                backend_http_settings_name  = "backendsettings-skax-dpmo-works-prod-http"
                priority                    = 470
              },
            ]

            redirect_configuration = [
              {
                name                  = "private-aihub-http-to-https-redirect"
                redirect_type         = "Permanent"
                include_path          = true
                include_query_string  = true
                target_listener_name  = "listener-private-aihub.skax.co.kr-https"
              },
              {
                name                  = "private-talentx-http-to-https-redirect"
                redirect_type         = "Permanent"
                include_path          = true
                include_query_string  = true
                target_listener_name  = "listener-private-talentx-dev.skax.co.kr-https"
              },
              {
                name                  = "public-aihub-http-to-https-redirect"
                redirect_type         = "Permanent"
                include_path          = true
                include_query_string  = true
                target_listener_name  = "listener-aihub.skax.co.kr-https"
              },
              {
                name                  = "talentx-dev-http-to-https-redirect"
                redirect_type         = "Permanent"
                include_path          = true
                include_query_string  = true
                target_listener_name  = "listener-talentx-dev.skax.co.kr-https"
              },
              {
                name                  = "private-dev-aipmo-http-to-https"
                redirect_type         = "Permanent"
                include_path          = true
                include_query_string  = true
                target_listener_name  = "listener-aipmo-dev.skax.co.kr-https"
              },
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
              },
              {
                name                  = "healthprobe-skax-dpmo"
                host                  = "dpmo.skax.co.kr"
                interval              = 60
                path                  = "/healthz"
                port                  = 80
                timeout               = 60
                unhealthy_threshold   = 3
                status_codes          = ["200-399"]
                backend_setting       = ["backendsettings-skax-dpmo-prod-http","backendsettings-skax-dpmo-works-prod-http","backendsettings-skax-dpmo-console-prod-http"]
              },
              {
                name                  = "healthprobe-agshub-prod"
                host                  = "agshub.skax.co.kr"
                interval              = 30
                path                  = "/healthz"
                port                  = 80
                timeout               = 30
                unhealthy_threshold   = 3
                status_codes          = ["200-399"]
                backend_setting       = ["backendsettings-skax-agshub-prod-http"]
              },
              {
                name                  = "healthprobe-agshub-dev"
                host                  = "agshub-dev.skax.co.kr"
                interval              = 30
                path                  = "/healthz"
                port                  = 80
                timeout               = 30
                unhealthy_threshold   = 3
                status_codes          = ["200-399"]
                backend_setting       = ["backendsettings-skax-agshub-dev-http"]
              },
              {
                name                  = "healthprobe-skax-talentx-prod"
                host                  = "talentax.skax.co.kr"
                interval              = 30
                path                  = "/healthz"
                port                  = 80
                timeout               = 30
                unhealthy_threshold   = 3
                status_codes          = ["200-500"]
                backend_setting       = ["backendsettings-skax-talentx-prod"]
              },
              {
                name                  = "healthprobe-skax-talentx-dev"
                host                  = "talentax-dev.skax.co.kr"
                interval              = 30
                path                  = "/healthz"
                port                  = 80
                timeout               = 30
                unhealthy_threshold   = 3
                status_codes          = ["200-500"]
                backend_setting       = ["backendsettings-skax-talentx-dev"]
              },
              {
                name                  = "healthprobe-skax-aihub-apim-https"
                host                  = "skax-int-aihub-apim.azure-api.net"
                interval              = 30
                path                  = "/status-0123456789abcdef"
                port                  = 443
                timeout               = 30
                unhealthy_threshold   = 3
                status_codes          = ["200-399"]
                backend_setting       = ["backendsettings-skax-aihub-apim-https"]
              },
              {
                name                  = "healthprobe-skax-aihub-apim"
                host                  = "aihub.skax.co.kr"
                interval              = 30
                path                  = "/status-0123456789abcdef"
                port                  = 80
                timeout               = 30
                unhealthy_threshold   = 3
                status_codes          = ["200-500"]
                backend_setting       = ["backendsettings-skax-aihub-apim"]
              }
            ]

            #waf_policy_id = "/subscriptions/122a2e7e-7d1a-4b2d-a26c-0a156dfa583c/resourceGroups/khkim-test-rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/waf-policy-khkim"
            
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