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

output attestor-build-name {
  value       = module.build-attestor.attestor
  description = "Attestor for the Build Validation"
}

output attestor-build-key {
  value       = module.build-attestor.key
  description = "Public Key for the Build Attestor"
}

output attestor-security-name {
  value       = module.security-attestor.attestor
  description = "Attestor for the Security Validation"
}

output attestor-security-key {
  value       = module.security-attestor.key
  description = "Public Key for the Build Attestor"
}

output attestor-qa-name {
  value       = module.quality-attestor.attestor
  description = "Attestor for the QA Validation"
}

output attestor-qa-key {
  value       = module.quality-attestor.key
  description = "Public Key for the QA Attestor"
}

output cicd-gsa-secret {
  value       = google_secret_manager_secret.cicd-build-gsa-key-secret.name
  description = "Name of the CICD Secret"
  depends_on  = []
}

output cicd-gsa-secret-version {
  value       = google_secret_manager_secret_version.cicd-build-gsa-key-secret-version.name
  description = "Secret containing the json credentials for the SA to be used in the CICD pipelines"
}

output "keyring-name" {
  value       = google_kms_key_ring.keyring.name
  description = "Keyring unique name"
}

output "eip-development-ingress" {
  value = length(google_compute_global_address.development-ingress) > 0 ? google_compute_global_address.development-ingress[0].address : null
}

output "eip-qa-ingress" {
  value = length(google_compute_global_address.qa-ingress) > 0 ? google_compute_global_address.qa-ingress[0].address : null
}

output "eip-production-ingress" {
  value = length(google_compute_global_address.prod-ingress) > 0 ? google_compute_global_address.prod-ingress[0].address : null
}
