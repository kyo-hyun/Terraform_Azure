# 🚀 Azure Infrastructure Automation with Terraform

## 📝 프로젝트 개요 (Overview)

본 프로젝트는 Terraform을 활용하여 Azure의 핵심 인프라 구성 요소를 코드(Infrastructure as Code, IaC)로 정의하고 배포하기 위한 모듈 및 예제 저장소입니다. 이는 **Azure 클라우드 환경의 일관된 배포와 운영 효율화**를 목표로 합니다.

**대상 Azure 서비스 (확장 예정):**
* **Networking:** Virtual Network (VNET), Subnet, Network Security Group (NSG)
* **Load Balancing & Security:** Application Gateway (AGW), Web Application Firewall (WAF) Policy
* **Compute:** Virtual Machine (VM), Azure Kubernetes Service (AKS)
* **Database & Storage:** (향후 추가 예정)

## 🏗️ 모듈 구조 및 사용 방법 (Module Structure and Usage)

본 저장소는 재사용 가능한 Terraform 모듈들을 구조화하여 관리합니다.

| 디렉토리/파일 | 설명 |
| :--- | :--- |
| `main.tf` | 인프라 구성의 메인 진입점. `locals.tf`의 설정 변수를 기반으로 모듈을 호출합니다. |
| `locals.tf` | **배포할 리소스의 상세 설정 (예: `AGW_List`, `VNET_List`)을 HCL 형식으로 정의하는 핵심 설정 파일입니다.** |
| `module/AGW/` | `azurerm_application_gateway` 리소스를 추상화하는 재사용 가능한 Terraform 모듈. |
| `module/VNET/` | VNet 및 Subnet 구성을 위한 모듈. |
| `variables.tf` | 모듈 외부에서 주입되는 변수 정의 (e.g., Global Prefix, Environment Tag 등). |

### 1. 배포 절차 (Deployment Steps)

Terraform을 사용하여 인프라를 배포하는 표준 절차입니다.

1.  **Azure 인증 설정:** Terraform 실행 환경에서 Azure 리소스에 접근할 수 있도록 인증을 구성합니다.
    ```bash
    # Azure CLI를 통한 인증 및 서비스 주체 설정 권장
    az login
    # 구독 설정 (필요시)
    az account set --subscription "<Your-Subscription-ID>"
    ```
2.  **설정 파일 업데이트:** `locals.tf` 파일을 수정하여 배포하고자 하는 리소스의 구성 정보를 정의합니다.
3.  **Terraform 초기화:** 모듈 의존성 및 백엔드 상태를 로드합니다.
    ```bash
    terraform init
    ```
4.  **배포 계획 확인:** 생성, 변경, 삭제될 리소스 목록을 검토합니다.
    ```bash
    terraform plan -out=tfplan
    ```
5.  **배포 실행:** 인프라 구성을 Azure에 적용합니다.
    ```bash
    terraform apply tfplan
    ```

### 2. AGW 설정 상세: HTTP to HTTPS 리다이렉션

Application Gateway에서 HTTP (Port 80) 요청을 HTTPS (Port 443)로 강제 전환하는 설정입니다. 이 기능을 구현하려면 `redirect_configuration`과 `request_routing_rules`를 함께 사용해야 합니다.

#### A. `locals.tf` 정의 예시

1.  **Redirect Configuration 정의 (리다이렉션 규칙)**
    ```terraform
        redirect_configuration = [
            {
                name                 = "http_to_https_redirect"
                redirect_type        = "Permanent" # 301 리다이렉션 권장
                include_path         = true
                include_query_string = true
                # HTTP 요청을 보낼 최종 HTTPS 리스너의 이름 지정
                target_listener_name = "listener-khkim-https" 
            }
        ]
    ```

2.  **Request Routing Rule 정의 (HTTP 리스너에 규칙 연결)**
    HTTP 리스너에 위에서 정의한 리다이렉션 구성을 연결하여, 모든 HTTP 요청을 HTTPS 리스너로 포워딩합니다.
    ```terraform
        request_routing_rules = [
            {
                name                        = "routingrule-http-redirect"
                rule_type                   = "Basic"
                listener_name               = "listener-khkim-http" # HTTP (Port 80) 리스너 이름
                # 백엔드 풀 대신 리다이렉션 구성을 연결
                redirect_configuration_name = "http_to_https_redirect" 
                priority                    = 100
            }
            # HTTPS 트래픽을 처리하는 별도의 Basic 또는 Path-Based 라우팅 규칙 필요
        ]
    ```

### 3. AGW 설정 상세: SSL/TLS 구성

#### A. SSL 인증서 (`ssl_certificates`) 설정

AGW에 TLS/SSL 인증서를 등록하여 HTTPS 트래픽을 처리할 수 있게 합니다.

* **PFX 파일 사용:** 로컬 PFX 파일을 Base64로 인코딩하여 제공합니다.
    ```terraform
    ssl_certificates = [
      {
        name                = "app-cert"
        password            = "cert_password" 
        data                = filebase64("./ssl/server.pfx") 
      }
    ]
    ```
* **Key Vault Secret ID 사용:** Azure Key Vault에 저장된 인증서를 참조할 수 있습니다.
    ```terraform
    ssl_certificates = [
      {
        name                = "kv-cert"
        key_vault_secret_id = "/subscriptions/.../secrets/cert-name/version"
      }
    ]
    ```

#### B. SSL 정책 (`ssl_policy`) 설정

보안 강화를 위해 AGW가 클라이언트 연결에 적용할 TLS 정책을 명시합니다.

```terraform
    ssl_policy = {
      policy_type          = "CustomV2"
      min_protocol_version = "TLSv1_2" # 최소 TLS 1.2 이상 권장
      cipher_suites = [
        "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256",
        "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
        # ... 보안 권고에 맞는 Cipher Suites 목록
      ]
    }