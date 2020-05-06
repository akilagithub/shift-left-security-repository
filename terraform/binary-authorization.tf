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
  keyring-id    = google_kms_key_ring.keyring.id
}

module "qa-binary-auth" {
  source = "./modules/binaryauth"
  # variables
  attestor-name = "qa"
  keyring-id    = google_kms_key_ring.keyring.id
}

module "security-binary-auth" {
  source = "./modules/binaryauth"
  # variables
  attestor-name = "security"
  keyring-id    = google_kms_key_ring.keyring.id
}

resource "google_binary_authorization_policy" "policy" {
  admission_whitelist_patterns {
    name_pattern = "quay.io/random-containers/*" # Only enable whitelisted repos, this is for demo purposes only
  }

  admission_whitelist_patterns {
    name_pattern = "k8s.gcr.io/more-random/*" # Adding a second policy
  }

  global_policy_evaluation_mode = "ENABLE"

  # Production ready (all attestors required)
  default_admission_rule {
    evaluation_mode         = "REQUIRE_ATTESTATION"
    enforcement_mode        = "ENFORCED_BLOCK_AND_AUDIT_LOG"
    require_attestations_by = [
      module.build-binary-auth.attestor,
      module.qa-binary-auth.attestor,
      module.security-binary-auth.attestor
    ]
  }
  # QA Environment Needs Build and Security
  cluster_admission_rules {
    cluster          = "${var.zone}.${google_container_cluster.qa.name}"
    evaluation_mode  = "REQUIRE_ATTESTATION"
    enforcement_mode = "ENFORCED_BLOCK_AND_AUDIT_LOG"
    require_attestations_by = [
      module.build-binary-auth.attestor,
      module.security-binary-auth.attestor
    ]
  }

}