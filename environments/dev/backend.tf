terraform {
  backend "gcs" {
    bucket = "procv-terraform-state-dev"  # Must be created manually first
    prefix = "dev/state"
  }
}
