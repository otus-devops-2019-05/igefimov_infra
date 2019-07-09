terraform {
  #  required_version = "0.11.7"
  #  required_version = "0.11.13"
}
provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region = "${var.region}"
}

resource "google_compute_instance" "app" {
  name = "reddit-app"
  machine_type = "g1-small"
  zone = "europe-west1-b"
  tags = [
    "reddit-app"]
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata {
    ssh-keys = "gcp:${file(var.public_key_path)}"
  }
  # Here we define Provisioners and how they connect to the VM(protocol, credentials)
  connection {
    type = "ssh"
    user = "gcp"
    agent = false
    private_key = "${file("/Users/efimovi/Otus/DevOps_course/.ssh/gcp")}"
  }

  provisioner "file" {
    source = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"
  network = "default"
  allow {
    protocol = "tcp"
    ports = [
      "9292"]
  }
  source_ranges = [
    "0.0.0.0/0"]
  target_tags = [
    "reddit-app"]
}
