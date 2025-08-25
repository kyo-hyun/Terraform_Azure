resource "azurerm_resource_group" "example" {
  name     = var.name
  location = var.location
  tags = {
        owner = "김교현"
      }
}