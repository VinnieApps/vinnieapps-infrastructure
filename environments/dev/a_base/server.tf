resource "random_password" "mysql_root" {
  length  = 50
  special = false
}

resource "random_password" "mysql_username" {
  length  = 25
  special = false
}

resource "random_password" "mysql_password" {
  length  = 50
  special = false
}

data "template_file" "dev_main_init_script" {
  template = file("${path.module}/templates/dev_main_init_script.sh")

  vars = {
    db_password   = random_password.mysql_password.result
    root_password = random_password.mysql_root.result
    db_username   = random_password.mysql_username.result
  }
}

resource "google_compute_instance" "dev_main" {
  name         = "dev-main-server"
  machine_type = "n1-standard-1"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  labels = {
    "environment" = var.environment
  }

  metadata_startup_script = data.template_file.dev_main_init_script.rendered

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    scopes = ["storage-ro"]
  }

  tags = [
    "web"
  ]
}