resource "google_dns_managed_zone" "sysdev_se" {
  name        = "sysdev-se-zone"
  dns_name    = var.domain
  project     = var.project_id
  description = "Public zone for ${var.domain}"
}

resource "google_dns_record_set" "records" {
  for_each     = { for r in var.records : r.name => r }
  project      = var.project_id
  managed_zone = google_dns_managed_zone.sysdev_se.name
  name         = each.value.name
  type         = each.value.type
  ttl          = each.value.ttl
  rrdatas      = each.value.rrdatas
}