locals {
  default_vm_service_account = var.vm_service_account
  vm_machines                = var.machines_list
  vm_zone                    = "${var.region_name}-a"
  image_types = {
    debian-11               = "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-11-bullseye-v20240312"
    debian-12               = "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-12-bookworm-v20240312"
    ubuntu-minimal-2004-lts = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2004-focal-v20240403"
    ubuntu-minimal-2204-lts = "https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2204-jammy-v20240318"
  }
}

resource "google_compute_instance" "default" {
  count = length(local.vm_machines)

  name         = local.vm_machines[count.index].name
  machine_type = local.vm_machines[count.index].machine_type
  zone         = local.vm_zone
  tags         = local.vm_machines[count.index].tags

  boot_disk {
    initialize_params {
      size  = local.vm_machines[count.index].boot_disk_size
      image = local.image_types[local.vm_machines[count.index].image]
    }
  }
  labels = {
    my_label = "terraform-machine"
  }

  network_interface {
    network = "default"
    access_config {
      // Configuration for access config
    }
  }

  metadata_startup_script = file("${path.module}/startup-script")

  service_account {
    email  = local.default_vm_service_account
    scopes = ["cloud-platform"]
  }
}
