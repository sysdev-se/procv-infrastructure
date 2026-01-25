output "project_id" {
  description = "The project ID"
  value       = module.project.project_id
}

output "project_number" {
  description = "The project number"
  value       = module.project.project_number
}

output "artifact_registry_url" {
  description = "Base Artifact Registry URL for dev"
  value       = module.artifact_registry.repository_url
}

/*
# Uncomment when deploying services
output "frontend_url" {
  description = "Frontend URL"
  value       = module.frontend.service_url
}

output "backend_url" {
  description = "Backend URL"
  value       = module.backend.service_url
}

output "database_connection_name" {
  description = "Cloud SQL connection name"
  value       = module.database.instance_connection_name
}
*/
