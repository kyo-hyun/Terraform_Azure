locals {
    lb_list = {
        # "lb-test" = {
        #     resource_group = "khkim_rg"
        #     location       = "koreacentral"
        #     public_type    = true
        #     sku            = "Standard"

        #     frontend_ip    = {
        #         public_ip  = "PIP-LB"
        #         # vnet       = "vnet-khkim"
        #         # subnet     = "lb-subnet"
        #         # private_ip = "10.0.0.69"
        #     }

        #     backend_pool = {
        #         "test-backend-pool" = {
        #             backend   = ["backend-2","backend-1"]
        #         }

        #         "test-backend-pool2" = {
        #             backend   = ["backend-2","backend-1"]
        #         }
        #     }

        #     lb_rule = {
        #         "test-rule" = {
        #             protocol      = "Tcp"
        #             frontend_port = 80
        #             backend_port  = 80
        #             backend_pool  = "test-backend-pool"
        #             health_probe  = "test-health-probe"
        #         }

        #         "test-rule2" = {
        #             protocol      = "Tcp"
        #             frontend_port = 800
        #             backend_port  = 800
        #             backend_pool  = "test-backend-pool2"
        #             health_probe  = "test-health-probe"
        #         }
        #     }

        #     health_probe = {
        #         "test-health-probe" = {
        #             protocol            = "Http"
        #             port                = 80
        #             request_path        = "/"
        #             interval_in_seconds = 5
        #             number_of_probes    = 2
        #         }
        #     }

        #     tags = {
        #         소유자 = "김교현"
        #     }
        # }
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
        subnet      = lookup(each.value.frontend_ip, "subnet", null) != null ? module.vnet[each.value.frontend_ip.vnet].get_subnet_id[each.value.subnet] : null
        private_ip  = lookup(each.value.frontend_ip, "private_ip", null) != null ? each.value.frontend_ip.private_ip : null
    }
    location        = each.value.location
    sku             = each.value.sku
    health_probe    = each.value.health_probe
    lb_rule         = each.value.lb_rule
    backend_pool    = [
        for backend_key, backend_value in each.value.backend_pool : {
            backend_pool_name = backend_key
            backend_pool      = { for backend in backend_value.backend : backend => try(module.azure_vm[backend].get_nic_id,backend) }
        }
    ]
    tags            = each.value.tags
}