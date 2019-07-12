terraform {
  #  required_version = "0.11.7"  #  required_version = "0.11.13"
}

provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region  = "${var.region}"
}
