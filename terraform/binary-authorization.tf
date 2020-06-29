resource "random_pet" "keyring-name" {
}

resource "null_resource" "resource-to-wait-on" {
  provisioner "local-exec" {
    command = "sleep 30" # 30 seconds
  }
  depends_on = [module.project-services.project_id]
}

resource "google_kms_key_ring" "keyring" {
  name     = "attestor-key-ring-${random_pet.keyring-name.id}"
  location = var.keyring-region
  lifecycle {
    prevent_destroy = false
  }
  depends_on = [null_resource.resource-to-wait-on]
}

module "quality-attestor" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/binary-authorization"

  project_id = var.project

  attestor-name = local.attestors[0]
  keyring-id    = google_kms_key_ring.keyring.id
}

# Create Builder attestor
module "build-attestor" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/binary-authorization"

  project_id = var.project

  attestor-name = local.attestors[1]
  keyring-id    = google_kms_key_ring.keyring.id
}

# Create Security attestor
module "security-attestor" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/binary-authorization"

  project_id = var.project

  attestor-name = local.attestors[2]
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
    evaluation_mode  = "REQUIRE_ATTESTATION"
    enforcement_mode = "ENFORCED_BLOCK_AND_AUDIT_LOG"
    require_attestations_by = [
      module.build-attestor.attestor,
      module.quality-attestor.attestor,
      module.security-attestor.attestor
    ]
  }
  # QA Environment Needs Build and Security
  cluster_admission_rules {
    cluster          = "${var.zone}.${google_container_cluster.qa.name}"
    evaluation_mode  = "REQUIRE_ATTESTATION"
    enforcement_mode = "ENFORCED_BLOCK_AND_AUDIT_LOG"
    require_attestations_by = [
      module.build-attestor.attestor,
      module.security-attestor.attestor
    ]
  }
  # QA Environment Needs Build and Security
  cluster_admission_rules {
    cluster          = "${var.zone}.${google_container_cluster.development.name}"
    evaluation_mode  = "REQUIRE_ATTESTATION"
    enforcement_mode = "ENFORCED_BLOCK_AND_AUDIT_LOG"
    require_attestations_by = [
      module.security-attestor.attestor
    ]
  }

}