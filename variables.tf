variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

// Marketplace requires this variable name to be declared
variable "goog_cm_deployment_name" {
  description = "The name of the deployment and VM instance."
  type        = string
}

variable "source_image" {
  description = "The image name for the disk for the VM instance."
  type        = string
  default     = "projects/mikopbx-public/global/images/image-mikopbx-2024-1-114-x86-64-v5"
}

variable "zone" {
  description = "The zone for the solution to be deployed."
  type        = string
  default     = "us-east1-b"
}

variable "machine_type" {
  description = "The machine type to create, e.g. e2-small"
  type        = string
  default     = "e2-small"
}

variable "boot_disk_type" {
  description = "The boot disk type for the VM instance."
  type        = string
  default     = "pd-balanced"
}

variable "boot_disk_size" {
  description = "The boot disk size for the VM instance in GBs"
  type        = number
  default     = 10
}

variable "storage_disk_type" {
  description = "Storage disk type"
  type        = string
  default     = "pd-balanced"
}

variable "storage_disk_size" {
  description = "Data storage disk size in GBs"
  type        = number
  default     = 50
}

variable "networks" {
  description = "The network name to attach the VM instance."
  type        = list(string)
  default     = ["default"]
}

variable "sub_networks" {
  description = "The sub network name to attach the VM instance."
  type        = list(string)
  default     = []
}

variable "external_ips" {
  description = "The external IPs assigned to the VM for public access."
  type        = list(string)
  default     = ["EPHEMERAL"]
}

variable "ip_forward" {
  description = "Whether to allow sending and receiving of packets with non-matching source or destination IPs."
  type        = bool
  default     = false
}

variable "enable_tcp_443_80" {
  description = "Allow HTTP traffic from the Internet"
  type        = bool
  default     = true
}

variable "tcp_443_80_source_ranges" {
  description = "Source IP ranges for HTTP traffic"
  type        = string
  default     = ""
}

variable "enable_tcp_5060" {
  description = "Allow TCP port 5060 traffic from the Internet"
  type        = bool
  default     = true
}

variable "tcp_5060_source_ranges" {
  description = "Source IP ranges for TCP port 5060 traffic"
  type        = string
  default     = ""
}

variable "enable_udp_5060" {
  description = "Allow UDP port 5060 traffic from the Internet"
  type        = bool
  default     = true
}

variable "udp_5060_source_ranges" {
  description = "Source IP ranges for UDP port 5060 traffic"
  type        = string
  default     = ""
}

variable "enable_tcp_5061" {
  description = "Allow TCP port 5061 traffic from the Internet"
  type        = bool
  default     = true
}

variable "tcp_5061_source_ranges" {
  description = "Source IP ranges for TCP port 5061 traffic"
  type        = string
  default     = ""
}

variable "udp_10000_10800_source_ranges" {
  description = "Source ranges for UDP ports 10000-10800"
  type        = string
  default     = ""
}
