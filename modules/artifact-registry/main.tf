locals {
  repository_id = "${var.base_repository_id}-${var.environment}"
}

resource "google_artifact_registry_repository" "docker_repo" {
  project       = var.project_id
  location      = var.region
  repository_id = local.repository_id
  description   = "Artifact Registry for ProCV ${var.environment} images"
  format        = "DOCKER"
}