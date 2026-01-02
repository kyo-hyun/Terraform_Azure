variable "name" {
    default = null
    type    = string
}

variable "location" {
    default = null
    type    = string
}

variable "subnets" {
    default = null
    type    = list
}

variable "tags" {
    default = null
    type    = map
}

variable "address_space" {
    default = null
    type    = list
}

variable "resource_group" {
    default = null
    type    = string
}