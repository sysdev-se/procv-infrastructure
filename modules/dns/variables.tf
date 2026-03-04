variable "project_id" {
  type = string
}

variable "domain" {
  description = "Base DNS name, e.g. sysdev.se."
  type        = string
}

variable "records" {
  description = "List of DNS records to create"
  type = list(object({
    name = string  # e.g. api.dev.procv.sysdev.se.
    type = string  # e.g. CNAME
    ttl  = number
    rrdatas = list(string)
  }))
}