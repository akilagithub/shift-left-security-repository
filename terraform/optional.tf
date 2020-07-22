# Resources in this file are optional and used for demonstration purposes only

# Create 3 elastic IPs, one for each environment to be used by Ingress controllers

resource "google_compute_global_address" "development-ingress" {
  count       = var.ingress-ip-addresses == true ? 1 : 0
  name        = "dev-ingress-ip"
  description = "IP Address for development environment's k8s Ingress"
}

resource "google_compute_global_address" "qa-ingress" {
  count       = var.ingress-ip-addresses == true ? 1 : 0
  name        = "qa-ingress-ip"
  description = "IP Address for QA environment's k8s Ingress"
}

resource "google_compute_global_address" "prod-ingress" {
  count       = var.ingress-ip-addresses == true ? 1 : 0
  name        = "prod-ingress-ip"
  description = "IP Address for prod environment's k8s Ingress"
}

