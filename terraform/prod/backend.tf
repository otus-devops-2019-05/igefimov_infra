terraform {
  #  required_version = "0.11.7"  #  required_version = "0.11.13"
  backend "gcs" {
    bucket = "tf-state-prod-bucket-igor"
    prefix = "terraform/state"
  }
}
