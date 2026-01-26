variable "service_name" {
  description = "Name of the Cloud Run service"
  type        = string
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "container_image" {
  description = "Container image to deploy"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables for the container"
  type        = map(string)
  default     = {}
}

variable "cpu_limit" {
  description = "CPU limit"
  type        = string
  default     = "1"
}

variable "memory_limit" {
  description = "Memory limit"
  type        = string
  default     = "512Mi"
}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 8080
}

variable "min_instances" {
  description = "Minimum number of instances"
  type        = number
  default     = 0
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 2
}

variable "allow_public_access" {
  description = "Allow public access to the service"
  type        = bool
  default     = true
}

variable "all_users_ingress_tag_value" {
  description = "TagValue resource ID (tagValues/NNNN) for allUsersIngress=True"
  type        = string
}

variable "labels" {
  description = "Labels to apply"
  type        = map(string)
  default     = {}
}
