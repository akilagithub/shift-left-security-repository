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
    bucket  = "binary-authorization-state"
    prefix  = "terraform/state"
  }
}

provider "random" {

}