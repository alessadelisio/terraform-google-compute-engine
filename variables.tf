variable "region_name" {
    type = string
    description = "default is us-central1"
    default = "us-central1"
}

variable "vm_service_account" {
    type = string
    default = "942147123973-compute@developer.gserviceaccount.com"
}

variable "machines_list" {
    type = list(
        object({
            name = string,
            boot_disk_size = number,
            machine_type = string,
            image = string
            tags = list(string)
        })
    )
    default = []

    validation {
      condition = alltrue([for vm in var.machines_list: contains(["debian-11", "debian-12", "ubuntu-minimal-2004-lts", "ubuntu-minimal-2204-lts"], vm.image)])
      error_message = "Some Image name in list is not valid"
    }

    validation {
      condition = alltrue([for vm in var.machines_list: contains(["e2-micro", "e2-small"], vm.machine_type)])
      error_message = "Some Machine type in list is not valid"
    }
}
