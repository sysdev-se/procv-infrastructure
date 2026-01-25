variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Display name of the project"
  type        = string
}

variable "project_id" {
  description = "Unique project ID"
  type        = string
}

variable "org_id" {
  description = "GCP Organization ID"
  type        = string
}

variable "billing_account" {
  description = "Billing account ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "asia-southeast1"
}

variable "client_image" {
  description = "Client container image"
  type        = string
  default     = "gcr.io/cloudrun/hello"  # Placeholder
}

variable "server_image" {
  description = "Server container image"
  type        = string
  default     = "gcr.io/cloudrun/hello"  # Placeholder
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "procv_dev"
}

variable "db_user" {
  description = "Database user"
  type        = string
  default     = "procv_user"
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}
