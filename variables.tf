variable "admin_users" {
  description = "Admin users configuration"
  type = map(object({
    pgp_key_base_64 = string
  }))
}

variable "service_users" {
  description = "Service users configuration"
  type = set(object({
    project         = string
    layer           = string
    service         = string
    groups          = set(string)
    pgp_key_base_64 = string
  }))
}
