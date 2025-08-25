# locals {
#     AGW_List = {
#         "AGW-khkim" = {
#             rg                      = "RG-KHKIM"
#             location                = "koreacentral"
#             identity_ids            = ["/subscriptions/122a2e7e-7d1a-4b2d-a26c-0a156dfa583c/resourceGroups/smjung-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mgid-koreacentral-smjung"]
#             vnet                    = "vnet-khkim-hub"
#             subnet                  = "agw-subnet"
#             public_ip               = "PIP-AGW"
#             private_ip              = "10.0.0.173"

#             sku = {
#                 name     = "WAF_v2"
#                 tier     = "WAF_v2"
#                 capacity = 2
#             }

#             # autoscale_configuration = {
#             #   min_capacity = 1
#             #   max_capacity = 15
#             # }

#             ssl_certificates = [
#               {
#                 name                = "khkim-test"
#                 key_vault_secret_id = "https://kv-eastus-smjung.vault.azure.net/secrets/khkim-test/ec5233336b7c4887a55cfe3b786f0e1c"
#                 password            = "test123"
#               }
#             ]

#             backend_address_pools = [
#                 {
#                   name         = "backend-web1"
#                   ip_addresses = ["10.0.0.165"]
#                 },
#                 {
#                   name         = "backend-web2"
#                   ip_addresses = ["10.0.0.166"]
#                 }
#             ]

#             backend_http_settings = [
#               {
#                 name                  = "backend-setting-web1"
#                 cookie_based_affinity = "Disabled"
#                 path                  = "/"
#                 enable_https          = false
#                 request_timeout       = 30
#                 host_name             = "test.example.com"
#                 probe_name            = "probe-web1"
#                 connection_draining = {
#                   enable_connection_draining = true
#                   drain_timeout_sec          = 300
#                 }
#               },
#               {
#                 name                  = "backend-setting-web2"
#                 cookie_based_affinity = "Enabled"
#                 path                  = "/"
#                 enable_https          = false
#                 request_timeout       = 30
#                 host_name             = "web2.example.com"
#               }
#             ]

#             http_listeners = [
#               {
#                 name                 = "listener-web1"
#                 host_name            = "test.example.com"
#                 ssl_certificate_name = "khkim-test"
#               },
#               {
#                 name                 = "listener-web2"
#                 host_name            = "web2.example.com"
#                 ssl_certificate_name = "khkim-test"
#               }
#             ]

#             request_routing_rules = [
#               {
#                 name                       = "rule-web1"
#                 rule_type                  = "Basic"
#                 http_listener_name         = "listener-web1"
#                 backend_address_pool_name  = "backend-web1"
#                 backend_http_settings_name = "backend-setting-web1"
#                 priority                   = 1
#               },
#               {
#                 name                       = "rule-web2"
#                 rule_type                  = "Basic"
#                 http_listener_name         = "listener-web2"
#                 backend_address_pool_name  = "backend-web2"
#                 backend_http_settings_name = "backend-setting-web2"
#                 priority                   = 2
#               }
#             ]

#             health_probes = [
#               {
#                 name                       = "probe-web1"
#                 host                       = "127.0.0.1"
#                 interval                   = 30
#                 path                       = "/"
#                 port                       = 80
#                 timeout                    = 30
#                 unhealthy_threshold        = 3
#               }
#             ]

#             waf_policy_id = "/subscriptions/122a2e7e-7d1a-4b2d-a26c-0a156dfa583c/resourceGroups/khkim-test-rg/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/waf-policy-khkim"
            
#         }
#     }
# }

# module "AGW" {
#     source      = "./module/AGW"
#     for_each    = local.AGW_List
    
#     name                    = each.key
#     rg                      = each.value.rg
#     location                = each.value.location
#     subnet                  = module.vnet[each.value.vnet].get_subnet_id[each.value.subnet]
#     backend_address_pools   = each.value.backend_address_pools
#     backend_http_settings   = each.value.backend_http_settings
#     public_ip               = module.pip[each.value.public_ip].get_pip_id
#     private_ip              = each.value.private_ip
#     sku                     = each.value.sku
#     identity_ids            = each.value.identity_ids
#     ssl_certificates        = each.value.ssl_certificates
#     request_routing_rules   = each.value.request_routing_rules
#     http_listeners          = each.value.http_listeners
#     health_probes           = each.value.health_probes
#     autoscale_configuration = try(each.value.autoscale_configuration,null)
#     waf_policy_id           = each.value.waf_policy_id
# }