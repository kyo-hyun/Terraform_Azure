# Terraform_Azure

### VM Module
os disk snapshot을 생성하고 source_os_sanpshot 부분에 넣으면 복제 생성된다.
신규 버전 vm resource 블록에서는 이미 생성된 osdisk를 사용할 수 없어 구 버전인 azurerm_virtual_machine를 사용하여 만든다.