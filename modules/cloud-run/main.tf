resource "google_cloud_run_v2_service" "service" {
  project  = var.project_id
  name     = var.service_name
  location = var.region

  template {
    containers {
      image = var.container_image

      dynamic "env" {
        for_each = var.environment_variables
        content {
          name  = env.key
          value = env.value
        }
      }

      resources {
        limits = {
          cpu    = var.cpu_limit
          memory = var.memory_limit
        }
      }

      dynamic "ports" {
        for_each = var.container_port != null ? [1] : []
        content {
          container_port = var.container_port
        }
      }
    }

    scaling {
      min_instance_count = var.min_instances
      max_instance_count = var.max_instances
    }
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  labels = var.labels

  lifecycle {
    ignore_changes = [
      template[0].containers,
    ]
  }
}

resource "google_tags_location_tag_binding" "all_users_ingress" {
  parent   = "//run.googleapis.com/projects/${google_cloud_run_v2_service.service.project}/locations/${google_cloud_run_v2_service.service.location}/services/${google_cloud_run_v2_service.service.name}"
  tag_value = var.all_users_ingress_tag_value
  location  = google_cloud_run_v2_service.service.location
}

# IAM to allow public access (if needed)
resource "google_cloud_run_v2_service_iam_member" "public_access" {
  count = var.allow_public_access ? 1 : 0

  project  = google_cloud_run_v2_service.service.project
  location = google_cloud_run_v2_service.service.location
  name     = google_cloud_run_v2_service.service.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

// new edit
# resource "google_cloud_run_domain_mapping" "api_domain_mapping" {
#   name     = "api.dev.procv.sysdev.se"
#   location = google_cloud_run_v2_service.service.location
#   project  = google_cloud_run_v2_service.service.project
#
#   metadata {
#     # Must match the project ID that owns the Cloud Run service
#     namespace = var.project_id
#   }
#
#   spec {
#     # Must be the Cloud Run service name
#     route_name = google_cloud_run_v2_service.service.name
#     # Optional: let Cloud Run manage TLS automatically (default)
#     certificate_mode = "AUTOMATIC"
#   }
#
#   depends_on = [
#     google_cloud_run_v2_service.service,
#     google_cloud_run_v2_service_iam_member.public_access
#   ]
# }