variable "name" { type = string }
variable "resource_group" { type = string }
variable "location" { type = string }
variable "assignments" {
  type = list(object({
    scope     = string
    role_name = string
  }))
  default = []
}