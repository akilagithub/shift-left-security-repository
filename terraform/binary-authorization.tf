/**
 * Copyright 2021 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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

# Create a Google Secret containing the keyring name
resource "google_secret_manager_secret" "keyring-secret" {
  provider = google-beta

  secret_id = "keyring-name"

  labels = {
    label = "keyring-name"
  }

  replication {
    automatic = true
  }

}

resource "google_secret_manager_secret_version" "keyring-secret-version" {
  provider = google-beta

  secret = google_secret_manager_secret.keyring-secret.id

  secret_data = google_kms_key_ring.keyring.name
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