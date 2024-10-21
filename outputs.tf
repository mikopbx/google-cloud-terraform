locals {
  network_interface = google_compute_instance.instance.network_interface[0]
  instance_nat_ip   = length(local.network_interface.access_config) > 0 ? local.network_interface.access_config[0].nat_ip : null
  instance_ip       = coalesce(local.instance_nat_ip, local.network_interface.network_ip)
  instance_id       = google_compute_instance.instance.instance_id
}

output "admin_url" {
  description = "URL of the web console (please wait 3 minutes after creation before accessing)"
  value       = "https://${local.instance_ip}/"
}

output "login_hint" {
  description = "Login hint for the web console."
  value       = "Username: admin, Password: ${local.instance_id}"
}

output "instance_self_link" {
  description = "Self-link for the compute instance."
  value       = google_compute_instance.instance.self_link
}

output "instance_zone" {
  description = "Zone for the compute instance."
  value       = var.zone
}

output "instance_machine_type" {
  description = "Machine type for the compute instance."
  value       = var.machine_type
}

output "instance_nat_ip" {
  description = "External IP of the compute instance."
  value       = local.instance_nat_ip
}

output "instance_network" {
  description = "Self-link for the network of the compute instance."
  value       = var.networks[0]
}