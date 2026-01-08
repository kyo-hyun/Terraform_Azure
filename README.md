# Azure Hub-Spoke Infrastructure Automation with Terraform

## 프로젝트 개요
본 프로젝트는 Terraform을 활용하여 Azure 클라우드 환경에 엔터프라이즈급 Hub-Spoke 네트워크 아키텍처를 구축하고 관리하기 위한 코드형 인프라(IaC) 포트폴리오입니다. 보안성(N-IDS, WAF), 중앙 집중형 권한 관리(UAMI), Private Link 기반의 폐쇄형 네트워크 구현을 핵심 목표로 합니다.

## 주요 특징
* **Hub-Spoke 네트워크 모델**: 중앙 Hub VNet을 통해 인/아웃바운드 트래픽을 통합 제어하며 보안 및 관리 효율성을 극대화했습니다.
* **심층 보안(Defense in Depth) 설계**: 
    * **N-IDS 통합**: 모든 수신 트래픽이 WAF에 도달하기 전 N-IDS를 통과하도록 설계하여 심층 패킷 검사를 수행합니다.
    * **Private Link 중심 네트워킹**: Storage, AKS API Server 등 주요 리소스를 Private Endpoint로 격리하여 공용 인터넷 노출을 차단했습니다.
* **중앙 집중식 권한 관리 (UAMI 모듈화)**: 
    * Identity 생성 및 Role Assignment를 전담 모듈로 분리하여 권한 관리의 일관성을 확보했습니다.
    * 리소스 생성 시 발생하는 RBAC 의존성 문제를 구조적으로 해결하여 배포 안정성을 높였습니다.
* **IaC 가독성 및 확장성**: `for_each` 구문과 `locals` 블록을 활용하여 변수 선언만으로 대규모 리소스를 동적으로 제어할 수 있는 구조를 채택했습니다.

## 아키텍처 구성
프로젝트는 기능적 역할에 따라 다음과 같이 계층화되어 있습니다.

* **Hub Layer (Shared Services)**:
    * **Network Appliances**: Application Gateway (WAF), Azure Firewall, N-IDS Cluster 배치.
    * **Routing**: UDR(User Defined Route)을 적용하여 Spoke 트래픽이 Hub 보안 영역을 강제 경유하도록 구성.
* **Spoke Layer (Workload)**:
    * **Workload**: AKS(Azure Kubernetes Service), VM Cluster 등 서비스 배치.
    * **Connectivity**: Hub VNet과의 Peering 및 중앙 Private DNS Zone 연동을 통한 내부 도메인 해석.
* **Identity & Governance**:
    * User-Assigned Managed Identity를 통한 최소 권한 원칙(PoLP) 준수.
    * 전역 Private DNS Zone 관리 및 VNet Link 자동화 구성.

![아키텍처 다이어그램](images/architecture.png)

## 프로젝트 구조
```text
.
├── module/                # 리소스별 재사용 가능 모듈
│   ├── AGW/               # Application Gateway & SSL 설정
│   ├── AKS/               # Private AKS Cluster (Azure CNI)
│   ├── UAMI/              # Managed Identity & Role Assignment 전담 모듈
│   ├── STG/               # Storage Account, Private Endpoint, File Share
│   ├── VNET/              # Virtual Network, Subnet, Peering
│   └── ...                # VM, NSG, UDR 등 독립 모듈
├── AGW.tf                 # Application Gateway 모듈 호출부
├── AKS.tf                 # AKS Cluster 및 노드 풀 구성부
├── UAMI.tf                # 전역 Identity 및 RBAC 정의
├── STG.tf                 # 스토리지 서비스 구성부
├── provider.tf            # AzureRM Provider 설정
├── secrets.yml            # (Local Only) 서비스 주체 인증 정보
└── README.md
시작하기
1. 인증 정보 설정
보안을 위해 서비스 주체(SPN) 정보를 외부 YAML 파일로 분리 관리합니다. 로컬 루트 디렉토리에 secrets.yml 파일을 생성하십시오.

YAML

subscription_id: "your-subscription-id"
client_id:       "your-spn-client-id"
client_secret:   "your-spn-client-secret"
tenant_id:       "your-tenant-id"
2. 실행 절차
Bash

# 모듈 및 프로바이더 초기화
terraform init

# 실행 계획 검토
terraform plan

# 인프라 배포
terraform apply -auto-approve