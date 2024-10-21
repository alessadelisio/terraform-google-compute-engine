variables {
  project_id = "test-project"
  machines_list = [
    {
      name           = "my-machine-gpincheiraa",
      boot_disk_size = 10,
      machine_type   = "e2-micro",
      image          = "debian-12",
      tags           = []
    },
  ]
}

provider "google" {
  project = var.project_id
  region  = "us-central1"
}

run "check_vms" {
  command = plan
}

run "check_not_valid_image" {
  command = plan

  variables {
    machines_list = [
      {
        name           = "my-machine-gpincheiraa",
        boot_disk_size = 10,
        machine_type   = "e2-micro",
        image          = "debian",
        tags           = []
      },
    ]
  }

  expect_failures = [
    var.machines_list
  ]
}

run "check_not_valid_machine" {
  command = plan

  variables {
    machines_list = [
      {
        name           = "my-machine-gpincheiraa",
        boot_disk_size = 10,
        machine_type   = "e2",
        image          = "debian-11",
        tags           = []
      },
    ]
  }

  expect_failures = [
    var.machines_list
  ]
}
