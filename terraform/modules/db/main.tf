resource "google_compute_instance" "db" {
  name         = "reddit-db-${count.index}"
  machine_type = "g1-small"
  zone         = "${var.zone}"

  count = "${var.instance_count}"

  tags = [
    "reddit-db",
  ]

  boot_disk {
    initialize_params {
      image = "${var.db_disk_image}"
    }
  }

  network_interface {
    network       = "default"
    access_config = {}
  }

  metadata {
    ssh-keys = "gcp:${file(var.public_key_path)}"
  }
}

resource "google_compute_firewall" "firewall_mongo" {
  name    = "allow-mongo-default"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }
  source_ranges = ["${var.external_ip_app}/32"]
  target_tags = ["reddit-db"]
  source_tags = ["reddit-app"]
}
