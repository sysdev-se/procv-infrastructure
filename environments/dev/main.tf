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
  # or Application Default Credentials locally.
}

# Create the dev project
module "project" {
  source = "../../modules/project"

  project_name    = var.project_name
  project_id      = var.project_id
  org_id          = var.org_id
  billing_account = var.billing_account

  labels = {
    environment = "dev"
    managed-by  = "terraform"
    application = "procv"
  }
}

# Note: Initially, you'll only deploy the project module
# Uncomment the modules below once the project is created and you're ready to deploy services

/*
module "frontend" {
  source = "../../modules/cloud-run"

  service_name    = "procv-frontend-dev"
  project_id      = module.project.project_id
  region          = var.region
  container_image = var.frontend_image

  environment_variables = {
    API_BASE_URL = module.backend.service_url
  }

  labels = {
    environment = "dev"
    tier        = "frontend"
  }

  depends_on = [module.project]
}

module "backend" {
  source = "../../modules/cloud-run"

  service_name    = "procv-backend-dev"
  project_id      = module.project.project_id
  region          = var.region
  container_image = var.backend_image

  environment_variables = {
    DB_CONNECTION_NAME = module.database.instance_connection_name
    DB_NAME            = module.database.database_name
    DB_USER            = var.db_user
    DB_PASSWORD        = var.db_password
  }

  labels = {
    environment = "dev"
    tier        = "backend"
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
