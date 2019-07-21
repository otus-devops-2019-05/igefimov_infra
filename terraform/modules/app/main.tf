resource "google_compute_instance" "app" {
  name         = "${var.env_prefix}-reddit-app-${count.index}"
  machine_type = "g1-small"
  zone         = "${var.zone}"

  count = "${var.instance_count}"

  tags = [
    "reddit-app",
  ]

  boot_disk {
    initialize_params {
      image = "${var.app_disk_image}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  metadata {
    ssh-keys = "gcp:${file(var.public_key_path)}"
  }

  # Here we define Provisioners and how they connect to the VM(protocol, credentials)
  connection {
    type        = "ssh"
    user        = "gcp"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }
  provisioner "file" {
    source      = "../files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "file" {
    source      = "../files/deploy.sh"
    destination = "/tmp/deploy.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "${var.autodeploy == true ? local.autodeploy : local.info}"
]
  }
}

locals {
  autodeploy="echo Environment='DATABASE_URL=${var.db_external_ip}:27017' >> '/tmp/puma.service' && sh /tmp/deploy.sh"
  info="echo 'No deploy'"
}

resource "google_compute_address" "app_ip" {
  name = "reddit-app-ip"
}

resource "google_compute_firewall" "firewall_puma" {
  name    = "allow-puma-default"
  network = "default"

  allow {
    protocol = "tcp"

    ports = [
      "9292",
    ]
  }

  source_ranges = [
    "0.0.0.0/0",
  ]

  target_tags = [
    "reddit-app",
  ]
}

resource "google_compute_firewall" "firewall_nginx" {
  name    = "allow-nginx-default"
  network = "default"

  allow {
    protocol = "tcp"

    ports = [
      "80",
    ]
  }

  source_ranges = [
    "0.0.0.0/0",
  ]

  target_tags = [
    "reddit-app",
  ]
}