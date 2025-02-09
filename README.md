# Terraform_Azure

### VM Module
os disk snapshot을 생성하고 source_os_sanpshot 부분에 넣으면 복제 생성된다.
신규 버전 vm resource 블록에서는 이미 생성된 osdisk를 사용할 수 없어 구 버전인 azurerm_virtual_machine를 사용하여 만든다.

data.azurerm_snapshot 이용하여 아이디를 불러오는데 아이디를 입력하는 것보다 이름이로 입력하는 게 보기 편할 것 같아서 이름을 입력하여 그 값을 변수로 받아 data를 이용하여 불러온다.