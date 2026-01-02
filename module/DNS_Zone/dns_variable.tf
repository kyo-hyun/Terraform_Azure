variable "name" {
    default = null
    type    = string
}

variable "rg" {
    default = null
    type    = string
}

variable "vnet_list" {
    default = null
    type    = map(string)
}