# ProCV Infrastructure

This repository contains Terraform infrastructure-as-code for the ProCV application platform.

## Architecture

- **Frontend**: Nuxt.js application deployed on Cloud Run
- **Backend**: Java Spring Boot application deployed on Cloud Run
- **Database**: Cloud SQL (PostgreSQL/MySQL)
- **Networking**: VPC with Private Service Connect

## Repository Structure

- `environments/`: Environment-specific configurations (dev, staging, prod)
- `modules/`: Reusable Terraform modules
- `.github/workflows/`: CI/CD pipelines

## Prerequisites

1. Google Cloud Organization set up
2. Billing account configured
3. GitHub repository secrets configured (see below)

## Required GitHub Secrets

- `GCP_PROJECT_NUMBER`: Bootstrap project number
- `GCP_PROJECT_ID`: Bootstrap project ID
- `GCP_WORKLOAD_IDENTITY_PROVIDER`: Full resource name of workload identity provider
- `GCP_SERVICE_ACCOUNT_EMAIL`: Terraform service account email
- `GCP_ORGANIZATION_ID`: Your GCP organization ID
- `GCP_BILLING_ACCOUNT`: Billing account ID

## Deployment

Each environment is deployed via GitHub Actions:
- **Dev**: Triggered on push to `develop` branch
- **Staging**: Triggered on push to `staging` branch
- **Prod**: Triggered on push to `main` branch

## Local Development

Infrastructure is managed using the Terraform CLI (`terraform` command).