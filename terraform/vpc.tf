resource "google_compute_firewall" "firewall_ssh" {
  name = "default-allow-ssh"
  description = "Allow SSH to any VM"
  network = "default"
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}
