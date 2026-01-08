variable "name" {
    default = null
}

variable "resource_group" {
    default = null
}

variable "location" {
    default = null
}

variable "account_tier" {
    default = null
}

variable "account_replication_type" {
    default = null
}

variable "infrastructure_encryption_enabled" {
    default = null
}

variable "https_traffic_only_enabled" {
    default = null
}

variable "file_shares" {
  type = map(object({
    quota = number
  }))
  default = {}
}

variable "pe_subnet_id" {
  type = string
}

variable "file_share_dns_zone" {
  type = string
}