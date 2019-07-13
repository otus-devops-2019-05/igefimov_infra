resource "google_compute_firewall" "firewall_ssh" {
  name        = "${var.env_prefix}-default-allow-ssh"
  description = "Allow SSH to any VM"
  network     = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["${var.source_ranges}"]
}
