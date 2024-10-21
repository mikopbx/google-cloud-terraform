provider "google" {
  project = var.project_id
}

locals {
  network_interfaces = [ for i, n in var.networks : {
    network     = n,
    subnetwork  = length(var.sub_networks) > i ? element(var.sub_networks, i) : null
    external_ip = length(var.external_ips) > i ? element(var.external_ips, i) : "NONE"
    }
  ]

  metadata = {
    google-logging-enable = "0"
    google-monitoring-enable = "0"
  }
}

resource "google_compute_instance" "instance" {
  name = "${var.goog_cm_deployment_name}-mikopbx-vm"
  machine_type = var.machine_type
  zone = var.zone

  tags = ["${var.goog_cm_deployment_name}-deployment"]

  boot_disk {
    device_name = "${var.goog_cm_deployment_name}-mikopbx-boot-disk"

    initialize_params {
      size = var.boot_disk_size
      type = var.boot_disk_type
      image = var.source_image
    }
  }
  
  attached_disk {
    source      = google_compute_disk.storage_disk.id
    device_name = "${var.goog_cm_deployment_name}-mikopbx-storage-disk"
  }
  
  can_ip_forward = var.ip_forward

  metadata = local.metadata

  dynamic "network_interface" {
    for_each = local.network_interfaces
    content {
      network = network_interface.value.network
      subnetwork = network_interface.value.subnetwork

      dynamic "access_config" {
        for_each = network_interface.value.external_ip == "NONE" ? [] : [1]
        content {
          nat_ip = network_interface.value.external_ip == "EPHEMERAL" ? null : network_interface.value.external_ip
        }
      }
    }
  }

  service_account {
    email = "default"
    scopes = compact([
      "https://www.googleapis.com/auth/cloud.useraccounts.readonly",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring.write"
    ])
  }
}

resource "google_compute_disk" "storage_disk" {
  name  = "${var.goog_cm_deployment_name}-mikopbx-storage-disk"
  size = var.storage_disk_size
  type = var.storage_disk_type
  zone  = var.zone
}

resource "google_compute_firewall" "tcp_443_80" {
  count = var.enable_tcp_443_80 ? 1 : 0

  name = "${var.goog_cm_deployment_name}-http-https-tcp-443-80"
  network = element(var.networks, 0)

  allow {
    ports = ["443", "80"]
    protocol = "tcp"
  }

  source_ranges = compact([for range in split(",", var.tcp_443_80_source_ranges) : trimspace(range)])

  target_tags = ["${var.goog_cm_deployment_name}-deployment"]
}

resource "google_compute_firewall" tcp_5060 {
  count = var.enable_tcp_5060 ? 1 : 0

  name = "${var.goog_cm_deployment_name}-sip-tcp-5060"
  network = element(var.networks, 0)

  allow {
    ports = ["5060"]
    protocol = "tcp"
  }

  source_ranges =  compact([for range in split(",", var.tcp_5060_source_ranges) : trimspace(range)])

  target_tags = ["${var.goog_cm_deployment_name}-deployment"]
}

resource "google_compute_firewall" udp_5060 {
  count = var.enable_udp_5060 ? 1 : 0

  name = "${var.goog_cm_deployment_name}-sip-udp-5060"
  network = element(var.networks, 0)

  allow {
    ports = ["5060"]
    protocol = "udp"
  }

  source_ranges =  compact([for range in split(",", var.udp_5060_source_ranges) : trimspace(range)])

  target_tags = ["${var.goog_cm_deployment_name}-deployment"]
}

resource "google_compute_firewall" tcp_5061 {
  count = var.enable_tcp_5061 ? 1 : 0

  name = "${var.goog_cm_deployment_name}-siptls-tcp-5061"
  network = element(var.networks, 0)

  allow {
    ports = ["5061"]
    protocol = "tcp"
  }

  source_ranges =  compact([for range in split(",", var.tcp_5061_source_ranges) : trimspace(range)])

  target_tags = ["${var.goog_cm_deployment_name}-deployment"]
}

resource "google_compute_firewall" "udp_10000_10800" {
  name    = "${var.goog_cm_deployment_name}-rtp-udp-10000-10800"
  network = element(var.networks, 0)

  allow {
    ports    = ["10000-10800"]
    protocol = "udp"
  }

  source_ranges = compact([for range in split(",", var.udp_10000_10800_source_ranges) : trimspace(range)])

  target_tags = ["${var.goog_cm_deployment_name}-deployment"]
}