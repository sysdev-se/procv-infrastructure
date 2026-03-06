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

  org_id          = var.org_id
  project_id      = var.project_id
  project_name    = var.project_name
  billing_account = var.billing_account

  labels = {
    environment = var.environment
    managed-by  = "terraform"
    application = "procv"
  }
}

module "drs" {
  source = "../../modules/drs"
  project_id = var.project_id
  org_id = var.org_id
  google_workspace_customer_id = var.google_workspace_customer_id
  depends_on = [module.project]
}

module "artifact_registry" {
  source = "../../modules/artifact-registry"
  project_id    = var.project_id
  environment   = var.environment
  region        = var.region
}

module "server" {
  source = "../../modules/cloud-run"
  project_id      = var.project_id
  service_name    = "procv-server-${var.environment}"
  container_image = var.server_image
  region          = var.region
  all_users_ingress_tag_value = var.all_users_ingress_tag_value
  labels = {
    environment = var.environment
    tier        = "server"
  }
  depends_on = [module.project, module.drs, module.artifact_registry]
}

// I just added this
module "dns" {
  source     = "../../modules/dns"
  project_id = var.project_id
  domain     = "sysdev.se."

  records = [
    # Cloud Run subdomain
    {
      name    = "api.dev.procv.sysdev.se."
      type    = "CNAME"
      ttl     = 300
      rrdatas = ["procv-server-dev-970065566826.europe-west1.run.app."]
    },
    # MX for sysdev.se (Google Workspace routing)
    {
      name    = "sysdev.se."
      type    = "MX"
      ttl     = 3600
      rrdatas = [
        "1 SMTP.GOOGLE.COM.",
      ]
    },
    # TXT for sysdev.se (both verification strings in one record set)
    {
      name    = "sysdev.se."
      type    = "TXT"
      ttl     = 3600
      rrdatas = [
        "\"google-site-verification=-CqIb55W1D2jILavmR8TxnehOjH2F7yAVB4fstts8qg\"",
        "\"google-site-verification=V1YOpmPPlj6BemlgzOZSqpu6eMh12gbN5t3Hyz9LcQg\"",
      ]
    },
    
    # www.sysdev.se CNAME
    {
      name    = "www.sysdev.se."
      type    = "CNAME"
      ttl     = 3600
      rrdatas = ["ghs.googlehosted.com."]
    },
  ]
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
