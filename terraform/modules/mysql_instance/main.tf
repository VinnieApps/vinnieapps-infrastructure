data "template_file" "init_script" {
  template = file("${path.module}/init_script_template.sh")
  vars = {
    db_name     = var.db_name
    db_password = var.db_password
  }
}

resource "google_compute_instance" "mysql_instance" {
  name = "${var.db_name}-${var.environment}-db-instance"
  machine_type = "g1-small"

  boot_disk {
    initialize_params {
      image = "gce-uefi-images/ubuntu-1804-lts"
    }
  }

  tags = [ "database", "mysql" ]

  labels = {
    environment = var.environment
  }

  metadata_startup_script = data.template_file.init_script.rendered

  network_interface {
    network = "default"

    access_config {}
  }
}

data "google_compute_network" "default" {
  name = "default"
}

data "google_compute_subnetwork" "default" {
  name   = "default"
  region = var.region
}

resource "google_compute_firewall" "mysql_ingress" {
  name    = "mysql-ingress"
  network = data.google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = [ "3306" ]
  }

  target_tags = ["mysql"]
}
