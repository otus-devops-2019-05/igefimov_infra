variable project {
  description = "Project ID"
}

variable region {
  description = "Region"

  # Default value
  default = "europe-west1"
}

variable public_key_path {
  # Variable description
  description = "Path to the public key used for ssh access"
}

variable disk_image {
  description = "Disk image"
}

variable private_key_path {
  description = "Path to the private key used for connection between terraform and GCP"
}

variable zone {
  description = "Zone where instance will be created"
  default     = "europe-west1-b"
}
