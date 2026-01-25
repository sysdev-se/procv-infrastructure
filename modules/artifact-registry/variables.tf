variable "project_id" {
  description = "GCP project ID where the repo is created"
  type        = string
}

variable "region" {
  description = "Artifact Registry region (e.g. europe-west1)"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
}

variable "base_repository_id" {
  description = "Base repo name without env suffix"
  type        = string
  default     = "artifact-registry"
}