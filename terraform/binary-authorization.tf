resource "random_pet" "keyring-name" {
}

resource "google_kms_key_ring" "keyring" {
  name     = "attestor-key-ring-${random_pet.keyring-name.id}"
  location = var.keyring-region
  lifecycle {
    prevent_destroy = false
  }
}

module "build-binary-auth" {
  source = "./modules/binaryauth"
  # variables
  attestor-name = "build"
  keyring-id = google_kms_key_ring.keyring.id
}

module "qa-binary-auth" {
  source = "./modules/binaryauth"
  # variables
  attestor-name = "qa"
  keyring-id = google_kms_key_ring.keyring.id
}

module "security-binary-auth" {
  source = "./modules/binaryauth"
  # variables
  attestor-name = "security"
  keyring-id = google_kms_key_ring.keyring.id
}