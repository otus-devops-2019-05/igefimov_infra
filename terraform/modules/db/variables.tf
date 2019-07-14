variable zone {
  description = "Zone where instance will be created"
  default     = "europe-west1-b"
}

variable instance_count {
  description = "Number of instances to start"
  default     = "1"
}

variable db_disk_image {
  description = "Disk image for VM where DB is running"
  default     = "reddit-db-only"
}

variable public_key_path {
  # Variable description
  description = "Path to the public key used for ssh access"
}

variable "external_ip_app" {
  description = "external ip from app-server for open firewall to mongodb"
}