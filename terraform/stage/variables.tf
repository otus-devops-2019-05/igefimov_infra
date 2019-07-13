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

variable app_disk_image {
  description = "Disk image for VM where app is deployed"
  default     = "reddit-ruby-only"
}

variable db_disk_image {
  description = "Disk image for VM where DB is running"
  default     = "reddit-db-only"
}

variable private_key_path {
  description = "Path to the private key used for connection between terraform and GCP"
}

variable zone {
  description = "Zone where instance will be created"
  default     = "europe-west1-b"
}

variable instance_count {
  description = "Number of instances to start"
  default     = "1"
}

variable autodeploy {
  description = "Deploys the app in case it is set to true"
  default     = "false"
}
