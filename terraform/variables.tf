variable project-id {
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
  default     = "1.15."
  description = "GKE Version"
}
