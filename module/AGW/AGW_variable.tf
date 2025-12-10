variable "name" {
    default = null
}

variable "rg" {
    default = null
}

variable "location" {
    default = null
}

variable "ssl_policy" {
    default = null
}

variable "subnet" {
    default = null
}

variable "backend_address_pools" {
    default = null
}

variable "backend_http_settings" {
    default = null
}

variable "public_ip" {
    default = null
}

variable "sku" {
    default = null
}

variable "autoscale_configuration" {
    default = null
}

variable "identity_ids" {
    default = null
}

variable "ssl_certificates" {
    default = null
}

variable "request_routing_rules" {
    default = null
}

variable "listeners" {
    default = null
}

variable "health_probes" {
    default = null
}

variable "private_ip" {
    default = null
}

variable "waf_policy_id" {
    default = null
}

variable "custom_waf_rule_name" {
  type        = string
  default     = null
}

variable "custom_waf_rule_priority" {
  type        = number
  default     = null
}

variable "custom_waf_rule_action" {
  type        = string
  default     = null
}

variable "redirect_configuration" {
  default     = null
}

variable "custom_waf_rule_ip_addresses" {
  type        = list(string)
  default     = null
}
