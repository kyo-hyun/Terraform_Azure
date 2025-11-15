variable "user_profile" {}

locals {
  spn_path = "C:/Users/${var.user_profile}/OneDrive - Cnthoth. Co., Ltd/작업 폴더/khkim-lab/authentication_key/azure_key.yaml"
  spn      = yamldecode(file(local.spn_path))
}

terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = "<=10000"
        }
    }

    # backend "azurerm" {
    #     resource_group_name  = "khkim-test-rg"
    #     storage_account_name = "khkimtest"
    #     container_name       = "tfstate"
    #     key                  = "prod.terraform.tfstate"
    # }

    required_version = ">=1.0"
}

provider "azurerm" {
    features {}
    tenant_id       = local.spn.AzureSPN.CNT_Plus_Tenant.tenant_id      
    client_id       = local.spn.AzureSPN.CNT_Plus_Tenant.client_id      
    client_secret   = local.spn.AzureSPN.CNT_Plus_Tenant.client_secret  
    subscription_id = local.spn.AzureSPN.CNT_Plus_Tenant.subscription_id
}