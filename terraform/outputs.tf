output attestor-build-name {
  value       = module.build-binary-auth.attestor
  description = "Attestor for the Build Validation"
}

output attestor-build-key {
  value       = module.build-binary-auth.key
  description = "Public Key for the Build Attestor"
}

output attestor-security-name {
  value       = module.security-binary-auth.attestor
  description = "Attestor for the Security Validation"
}

output attestor-security-key {
  value       = module.security-binary-auth.key
  description = "Public Key for the Build Attestor"
}

output attestor-qa-name {
  value       = module.qa-binary-auth.attestor
  description = "Attestor for the QA Validation"
}

output attestor-qa-key {
  value       = module.qa-binary-auth.key
  description = "Public Key for the QA Attestor"
}
