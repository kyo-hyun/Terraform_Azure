variable "name" {
  default = null
  type    = string
}

variable "rg" {
  default = null
  type    = string
}

variable "location" {
  default = null
  type    = string
}

variable "namespaces" {
  default = null
  type    = list
}

variable "tags" {
  default = null
  type    = map
}

variable "law_id" {
  default = null
  type    = string
}

variable "aks_id" {
  default = null
  type    = string
}