locals {
    pip_list = {
        "pip-khkim-windows" = {
            rg          = "khkim_test"
            location    = "koreacentral"
            tags = {
                owner   = "김교현"
            }
        }

        "pip-khkim-ubuntu" = {
            rg          = "khkim_test"
            location    = "koreacentral"
            tags = {
                owner   = "김교현"
            }
        }
    }
}

module "pip" {
    for_each = local.pip_list
    source   = "./module/PIP"
    name     = each.key
    rg       = each.value.rg
    location = each.value.location
    tags     = each.value.tags
}