Terraform Azure Modules

본 리포지토리는 Azure 인프라를 Terraform 기반으로 선언적이고 일관되게 배포하기 위한 모듈(Module) 집합을 제공한다.
VNET, VM, Application Gateway(AGW), AKS 등 다양한 Azure 리소스를 단일 코드베이스에서 효율적으로 관리할 수 있도록 구성되어 있다.

주요 특징

서비스별 독립된 Terraform 모듈 제공

module/AGW

module/VM

module/VNET

module/AKS

기타 리소스 지속 추가 예정

반복 배포를 고려한 로컬 맵 기반 변수 구조

Dynamic Block 기반의 유연한 설정(Listener, Rule, Health Probe 등)

Public/Private Frontend, SSL Policy, Autoscale, Redirect 등 AGW의 모든 주요 기능 지원

실제 운영 환경에서 확장 가능한 구조를 지향

Repository 구조
Terraform_Azure/
│
├── module/
│   ├── AGW/
│   ├── VM/
│   ├── VNET/
│   ├── AKS/
│   └── ...
│
├── examples/
│   └── agw_basic/
│
└── main.tf

사용 방법
1. Provider / Backend 구성

루트 디렉터리에서 다음과 같이 Provider 및 Backend를 설정한다.

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstg"
    container_name       = "state"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

Application Gateway(AGW) 모듈

AGW 모듈은 Azure Application Gateway의 모든 주요 기능을 지원하며, Public/Private IP, SSL, Listener, Redirect, Routing Rule, Autoscale 등을 Terraform으로 완전히 정의할 수 있다.

1. locals.tf 내 정의 예시
locals {
  AGW_List = {
    "agw-khkim" = {
      rg        = "khkim_rg"
      location  = "koreacentral"
      vnet      = "Hub-vnet"
      subnet    = "agw-subnet"

      public_ip  = "PIP-LB"
      private_ip = "10.0.5.173"

      ssl_policy = {
        policy_type          = "CustomV2"
        min_protocol_version = "TLSv1_2"
        cipher_suites = [
          "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
        ]
      }

      sku = {
        name     = "Standard_v2"
        tier     = "Standard_v2"
        capacity = 1
      }

      ssl_certificates = [
        {
          name     = "khkim-test"
          password = "test123"
          data     = filebase64("./ssl/server.pfx")
        }
      ]

      backend_address_pools = [
        {
          name         = "backendpool-khkim"
          ip_addresses = ["10.0.7.5"]
        }
      ]

      backend_http_settings = [
        {
          name         = "backendsettings-khkim"
          port         = 3000
          enable_https = false
          probe_name   = "healthprobe-khkim"
        }
      ]

      listeners = [
        {
          name             = "listener-khkim-http"
          frontend_ip_type = "public"
          port             = 80
        }
      ]

      request_routing_rules = [
        {
          name                       = "rule-khkim"
          rule_type                  = "Basic"
          priority                   = 120
          listener_name              = "listener-khkim-http"
          backend_address_pool_name  = "backendpool-khkim"
          backend_http_settings_name = "backendsettings-khkim"
        }
      ]

      health_probes = [
        {
          name         = "healthprobe-khkim"
          path         = "/sse"
          port         = 3000
          status_codes = ["200-399"]
        }
      ]
    }
  }
}

2. AGW 모듈 호출
module "AGW" {
  source   = "./module/AGW"
  for_each = local.AGW_List

  name                    = each.key
  rg                      = each.value.rg
  location                = each.value.location
  subnet                  = module.vnet[each.value.vnet].get_subnet_id[each.value.subnet]

  ssl_policy              = each.value.ssl_policy
  ssl_certificates        = each.value.ssl_certificates

  backend_address_pools   = each.value.backend_address_pools
  backend_http_settings   = each.value.backend_http_settings
  listeners               = each.value.listeners
  request_routing_rules   = each.value.request_routing_rules
  health_probes           = each.value.health_probes

  public_ip               = try(module.pip[each.value.public_ip].get_pip_id, null)
  private_ip              = each.value.private_ip

  sku                     = each.value.sku
  autoscale_configuration = try(each.value.autoscale_configuration, null)
  identity_ids            = try(each.value.identity_ids, null)
  waf_policy_id           = try(each.value.waf_policy_id, null)
}

Redirect 구성 방법

Application Gateway는 특정 Listener로 들어온 요청을 다른 Listener로 Redirect할 수 있다.
가장 일반적인 예시는 HTTP → HTTPS 자동 Redirect이다.

HTTP → HTTPS Redirect 예시
redirect_configuration = [
  {
    name                 = "redirect-http-to-https"
    redirect_type        = "Permanent"
    include_path         = true
    include_query_string = true
    target_listener_name = "listener-https"
  }
]

listeners = [
  {
    name             = "listener-http"
    port             = 80
    frontend_ip_type = "public"
  },
  {
    name                 = "listener-https"
    port                 = 443
    frontend_ip_type     = "public"
    ssl_certificate_name = "khkim-cert"
  }
]

request_routing_rules = [
  {
    name                        = "redirect-rule"
    rule_type                   = "Basic"
    listener_name               = "listener-http"
    redirect_configuration_name = "redirect-http-to-https"
    priority                    = 100
  }
]

VNET, VM, AKS 등 추가 모듈 사용 예시

본 리포지토리는 AGW뿐만 아니라 VM, VNET, AKS 등 다른 서비스도 모듈화하여 제공한다.

VNET 예시
module "vnet" {
  source = "./module/VNET"

  name          = "Hub-vnet"
  rg            = "khkim_rg"
  location      = "koreacentral"
  address_space = ["10.0.0.0/16"]

  subnets = {
    agw-subnet = "10.0.5.0/24"
    vm-subnet  = "10.0.7.0/24"
  }
}

VM 예시
module "vm" {
  source = "./module/VM"

  name      = "khkim-ubuntu"
  rg        = "khkim_rg"
  subnet_id = module.vnet["Hub-vnet"].get_subnet_id["vm-subnet"]
  size      = "Standard_B2ms"
}

AKS 예시
module "aks" {
  source = "./module/AKS"

  name              = "skax-adxp-aks"
  rg                = "khkim_rg"
  location          = "koreacentral"
  default_node_pool = { name = "system", vm_size = "Standard_D4ds_v5" }
}

배포 절차
terraform init
terraform plan
terraform apply

주의사항

AGW Subnet은 /27 이상의 크기가 필요하다.

SSL 인증서는 Key Vault 또는 local pfx(Base64) 방식 중 선택 가능하다.

Public / Private Frontend를 동시에 사용할 경우 필수 값이 모두 정의되어 있어야 한다.

다른 모듈과 연동 시 subnet/VNET 참조를 일관되게 유지해야 한다.

속성 누락·오타는 AGW Validation 단계에서 오류로 나타날 수 있으므로 주의한다.