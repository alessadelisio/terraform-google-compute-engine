output "machine_ips" {
  description = "Object with name-ip pair"
  value = zipmap(
    google_compute_instance.default[*].name,
    google_compute_instance.default[*].network_interface[0].access_config[0].nat_ip
  )
}

