output "instance_name" {
  description = "Cloud SQL instance name"
  value       = google_sql_database_instance.instance.name
}

output "instance_connection_name" {
  description = "Connection name for Cloud SQL Proxy"
  value       = google_sql_database_instance.instance.connection_name
}

output "database_name" {
  description = "Database name"
  value       = google_sql_database.database.name
}

output "private_ip_address" {
  description = "Private IP address"
  value       = google_sql_database_instance.instance.private_ip_address
}

output "public_ip_address" {
  description = "Public IP address"
  value       = google_sql_database_instance.instance.public_ip_address
}
