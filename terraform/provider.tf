provider "google" {
  project = "binary-authorization"
  region  = "us-central1"
}

provider "google-beta" {
  project = "binary-authorization"
  region  = "us-central1"
}

terraform {

  backend "gcs" {
    prefix  = "terraform/state"
  }
}

provider "random" {}
