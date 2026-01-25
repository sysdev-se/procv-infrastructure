terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  # Authentication handled by Workload Identity Federation in GitHub Actions
  # or Application Default Credentials locally
}

# Create the dev project
module "project" {
  source = "../../modules/project"

  project_name    = var.project_name
  project_id      = var.project_id
  org_id          = var.org_id
  billing_account = var.billing_account

  labels = {
    environment = var.environment
    managed-by  = "terraform"
    application = "procv"
  }
}

module "artifact_registry" {
  source = "../../modules/artifact-registry"

  project_id    = module.project.project_id
  region        = var.region
  environment   = var.environment
}

module "server" {
  source = "../../modules/cloud-run"

  service_name    = "procv-server-dev"
  project_id      = module.project.project_id
  region          = var.region
  container_image = var.server_image

  labels = {
    environment = var.environment
    tier        = "server"
  }

  depends_on = [module.project]
}

# Note: Initially, you'll only deploy the project module
# Uncomment the modules below once the project is created and you're ready to deploy services

/*
module "client" {
  source = "../../modules/cloud-run"

  service_name    = "procv-client-dev"
  project_id      = module.project.project_id
  region          = var.region
  container_image = var.frontend_image

  environment_variables = {
    API_BASE_URL = module.backend.service_url
  }

  labels = {
    environment = "dev"
    tier        = "client"
  }

  depends_on = [module.project]
}

module "database" {
  source = "../../modules/cloud-sql"

  instance_name     = "procv-db-dev"
  project_id        = module.project.project_id
  region            = var.region
  database_version  = "POSTGRES_15"
  database_name     = var.db_name
  database_user     = var.db_user
  database_password = var.db_password

  tier                  = "db-f1-micro"
  deletion_protection   = false  # Allow deletion in dev
  public_ip_enabled     = true   # For easier dev access

  depends_on = [module.project]
}
*/
