variable source_ranges {
  description = "Allowed IP addresses"
  default     = ["0.0.0.0/0"]
}

variable env_prefix {
  description = "Prefix for the environment. Can be used in the name of firewall rule"
  default     = "stage"
}
