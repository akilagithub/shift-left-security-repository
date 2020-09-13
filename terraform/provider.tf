provider "google" {
  project = "binary-authorization"
  region  = "us-central1"
}

provider "google-beta" {
  project = "binary-authorization"
  region  = "us-central1"
}

terraform {
  # Authentication provided by ~/.terraformrc credentails configuration
  backend "remote" {

    organization = "google-cloud-solution-architects"

    workspaces {
      name = "secure-cicd-blueprint"
    }
  }
}

provider "random" {}
