resource "random_pet" "server" {}

locals {
  petname = random_pet.server.id
  admin_enabled_apis = [
    "compute.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "containeranalysis.googleapis.com",
    "binaryauthorization.googleapis.com",
    "container.googleapis.com",
    "cloudkms.googleapis.com",
    "secretmanager.googleapis.com"
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

resource "google_service_account" "cicd-build-gsa" {
  project = var.project-id
  account_id   = "cicd-builds"
  display_name = "CICD Pipeline builder Google Service Account (GSA)"
  description  = "GSA for CICD builds and GCR pushes"
}

resource "google_project_iam_member" "cicd-permissions" {
  project = var.project-id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.cicd-build-gsa.email}"
}

resource "google_service_account_key" "cicd-build-gsa-key" {
  service_account_id = google_service_account.cicd-build-gsa.name
}

resource "google_secret_manager_secret" "cicd-build-gsa-key-secret" {
  provider = google-beta

  secret_id = "cicd-build-gsa-key"

  labels = {
    label = "gsa-service-key"
  }

  replication {
    automatic = true
  }

}

resource "google_secret_manager_secret_version" "cicd-build-gsa-key-secret-version" {
  provider = google-beta

  secret = google_secret_manager_secret.cicd-build-gsa-key-secret.id

  secret_data = google_service_account_key.cicd-build-gsa-key.private_key
}


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