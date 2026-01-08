locals {
    lb_list = {
        "hub-n-ids-untrust-lb" = {
            resource_group = "Hub_rg"
            location       = "koreacentral"
            public_type    = false
            sku            = "Standard"

            frontend_ip    = {
                vnet       = "hub-vnet"
                subnet     = "n-ids-untrust-snet"
                private_ip = "10.0.0.36"
            }

            backend_pool = {
                "n-ids-untrust-pool" = {
                    backend = [
                      { name = "hub-n-ids1-vm", nic_type = "primary" },
                      { name = "hub-n-ids2-vm", nic_type = "primary" }
                    ]
                }
            }

            lb_rule = {
                "nids-ha-rule" = {
                    protocol      = "All"
                    frontend_port = 0
                    backend_port  = 0
                    backend_pool  = "n-ids-untrust-pool"
                    health_probe  = "nids-health-probe"
                }
            }

            health_probe = {
                "nids-health-probe" = {
                    protocol            = "Http"
                    port                = 80
                    request_path        = "/"
                    interval_in_seconds = 5
                    number_of_probes    = 2
                }
            }

            tags = {
                Env = "Hub"
                Role = "Inbound-LB"
            }
        }

        "hub-n-ids-trust-lb" = {
            resource_group = "Hub_rg"
            location       = "koreacentral"
            public_type    = false
            sku            = "Standard"

            frontend_ip    = {
                vnet       = "hub-vnet"
                subnet     = "n-ids-trust-snet"
                private_ip = "10.0.0.52"
            }

            backend_pool = {
                "n-ids-trust-pool" = {
                    backend = [
                      { name = "hub-n-ids1-vm", nic_type = "secondary" },
                      { name = "hub-n-ids2-vm", nic_type = "secondary" }
                    ]
                }
            }

            lb_rule = {
                "nids-ha-rule" = {
                    protocol      = "All"
                    frontend_port = 0
                    backend_port  = 0
                    backend_pool  = "n-ids-trust-pool"
                    health_probe  = "nids-health-probe"
                }
            }

            health_probe = {
                "nids-health-probe" = {
                    protocol            = "Http"
                    port                = 80
                    request_path        = "/"
                    interval_in_seconds = 5
                    number_of_probes    = 2
                }
            }

            tags = {
                Env = "Hub"
                Role = "Outbound-LB"
            }
        }
    }
}

module "LB" {
    source          = "./module/LB"
    for_each        = local.lb_list
    name            = each.key
    resource_group  = each.value.resource_group
    public_type     = each.value.public_type
    frontend_ip     = {
        public_ip   = lookup(each.value.frontend_ip, "public_ip", null) != null ? module.pip[each.value.frontend_ip.public_ip].get_pip_id : null
        subnet      = lookup(each.value.frontend_ip, "subnet", null) != null ? module.vnet[each.value.frontend_ip.vnet].get_subnet_id[each.value.frontend_ip.subnet] : null
        private_ip  = lookup(each.value.frontend_ip, "private_ip", null) != null ? each.value.frontend_ip.private_ip : null
    }
    location        = each.value.location
    sku             = each.value.sku
    health_probe    = each.value.health_probe
    lb_rule         = each.value.lb_rule
    backend_pool = [
      for pool_name, pool_content in each.value.backend_pool : {
        backend_pool_name = pool_name
        backend_pool = {
          for target in pool_content.backend :
            target.name => {
              id   = try(module.azure_vm[target.name].nic_ids[target.nic_type], module.azure_vm[target.name].get_nic_id)
              type = target.nic_type
            }
        }
      }
    ]

    tags            = each.value.tags
}