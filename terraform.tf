terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.5"
    }
    github = {
      source  = "integrations/github"
      version = ">= 5.9.1"
    }
  }
  # https://www.terraform.io/language/settings/backends/gcs
  backend "gcs" {
    bucket = "385711-bucket-tfstate"
    prefix = "wif-terraform/state"
  }
}

provider "google" {
  project = var.GOOGLE_PROJECT
  region  = var.GOOGLE_REGION
}

provider "github" {
  owner = var.GITHUB_OWNER
  token = var.GITHUB_TOKEN
}
