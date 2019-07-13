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
  default     = "reddit-ruby-only"
}

variable public_key_path {
  # Variable description
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  # Variable description
  description = "Path to the private key used by Provisioners(section in resource 'google_compute_instance' 'app') toconnect to the VM and do the job"
}

variable env_prefix {
  description = "Prefix for the environment. Can be used in the name of VM"
  default     = "stage"
}

variable autodeploy {
  description = "Deploys the app in case it is set to true"
  default     = "false"
}

variable "db_external_ip" {
  default = "127.0.0.1"
}
