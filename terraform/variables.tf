variable project {
  type        = string
  description = "Project ID (duplciated from provider)"
}

variable keyring-region {
  type        = string
  default     = "us-central1"
  description = "Region used for key-ring"
}

variable zone {
  type        = string
  default     = "us-central1-a"
  description = "GKE Node Zone"
}


variable gke-version {
  type        = string
  default     = "1.16."
  description = "GKE Version"
}

variable "ingress-ip-addresses" {
  type        = bool
  description = "Create static IP addresses for Ingress controllers (optional)"
  default     = false
}
