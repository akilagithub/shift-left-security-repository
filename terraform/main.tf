locals {
  petname = random_pet.server.id
  admin_enabled_apis = [
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "containeranalysis.googleapis.com",
    "binaryauthorization.googleapis.com",
    "container.googleapis.com",
    "cloudkms.googleapis.com"
  ]
}

data "google_container_engine_versions" "central1b" {
  location       = var.zone
  version_prefix = var.gke-version
}

resource "google_project_service" "enabled-apis" {
  for_each                   = toset(local.admin_enabled_apis)
  project                    = var.project-id
  service                    = each.value
  disable_dependent_services = true
  disable_on_destroy         = true
}

resource "random_pet" "server" {}

resource "google_container_cluster" "primary" {
  name                        = "bin-auuth-${local.petname}"
  location                    = var.zone
  enable_binary_authorization = true
  node_version                = data.google_container_engine_versions.central1b.latest_node_version
  min_master_version          = data.google_container_engine_versions.central1b.latest_node_version
  initial_node_count          = 1
  resource_labels = {
    environment = "development"
  }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    preemptible  = true
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

  }

  timeouts {
    create = "30m"
    update = "40m"
  }
  depends_on = [google_project_service.enabled-apis]
}

resource "google_container_cluster" "qa" {
  name                        = "bin-auth-qa-${local.petname}"
  location                    = var.zone
  enable_binary_authorization = true
  node_version                = data.google_container_engine_versions.central1b.latest_node_version
  min_master_version          = data.google_container_engine_versions.central1b.latest_node_version
  initial_node_count          = 1
  resource_labels = {
    environment = "qa"
  }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    preemptible  = true
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

  }

  timeouts {
    create = "30m"
    update = "40m"
  }
  depends_on = [google_project_service.enabled-apis]
}

resource "google_container_cluster" "production" {
  name                        = "bin-auth-prod-${local.petname}"
  location                    = var.zone
  enable_binary_authorization = true
  node_version                = data.google_container_engine_versions.central1b.latest_node_version
  min_master_version          = data.google_container_engine_versions.central1b.latest_node_version
  initial_node_count          = 1
  resource_labels = {
    environment = "production"
  }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    preemptible  = true
    machine_type = "n1-standard-1"

    metadata = {
      disable-legacy-endpoints = "true"
    }

  }

  timeouts {
    create = "30m"
    update = "40m"
  }
  depends_on = [google_project_service.enabled-apis]
}