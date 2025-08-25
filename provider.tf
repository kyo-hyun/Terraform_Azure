locals {
    #spn = yamldecode(file("F:/terraform-workspace/Authentication/authentication.yml"))
    spn = yamldecode(file("C:/khkim-lab/authentication_key/azure_key.yaml"))
}

terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "<=10000"
        }
    }

    required_version = ">=1.0"
}

provider "azurerm" {
    features {}
    tenant_id       = local.spn.AzureSPN.CNT_Tenant.tenant_id      
    client_id       = local.spn.AzureSPN.CNT_Tenant.client_id      
    client_secret   = local.spn.AzureSPN.CNT_Tenant.client_secret  
    subscription_id = local.spn.AzureSPN.CNT_Tenant.subscription_id
}