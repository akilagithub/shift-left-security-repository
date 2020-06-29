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
