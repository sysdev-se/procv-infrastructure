terraform {
  backend "gcs" {
    bucket = "sysdev-tfstate"
    prefix = "procv/dev"
  }
}
