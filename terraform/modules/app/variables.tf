variable zone {
  description = "Zone where instance will be created"
  default     = "europe-west1-b"
}

variable instance_count {
  description = "Number of instances to start"
  default     = "1"
}

variable app_disk_image {
  description = "Disk image for VM where app is deployed"
  default = "reddit-ruby-only"
}

variable public_key_path {
  # Variable description
  description = "Path to the public key used for ssh access"
}
