### Storage Settings ###
variable "storage_name" {
  type    = string
  default = "default"

  validation {
    condition     = length(var.storage_name) > 0
    error_message = "The storage_name variable must be longer than 0 characters."
  }
}

variable "maas_profile_name" {
  type    = string
  default = "default"

  validation {
    condition     = length(var.maas_profile_name) > 0
    error_message = "The maas_profile_name variable must be longer than 0 characters."
  }
}

### Network Settings ###
variable "maas_oam_ipv4_network_address" {
  type    = string
  default = "10.250.120.1/24"

  validation {
    condition     = can(cidrhost(var.maas_oam_ipv4_network_address, 1))
    error_message = "Must be a valid IPv4 CIDR (e.g., 10.250.120.1/24)."
  }
}

variable "maas_oam_ipv4_host_address" {
  type    = string
  default = "10.250.120.2"

  validation {
    condition     = can(cidrhost("${var.maas_oam_ipv4_host_address}/32", 0))
    error_message = "Must be a valid single IPv4 address. (e.g. 10.250.120.2)"
  }
}

variable "maas_oam_ipv4_subnet_start" {
  type    = string
  default = "10.250.120.23"

  validation {
    condition     = can(cidrhost("${var.maas_oam_ipv4_subnet_start}/32", 0))
    error_message = "Must be a valid single IPv4 address. (e.g. 10.250.120.23)"
  }
}

variable "maas_oam_ipv4_subnet_end" {
  type    = string
  default = "10.250.120.87"

  validation {
    condition     = can(cidrhost("${var.maas_oam_ipv4_subnet_end}/32", 0))
    error_message = "Must be a valid single IPv4 address. (e.g. 10.250.120.87)"
  }
}

variable "maas_oam_network_ipv4_nat" {
  type    = bool
  default = true
}

variable "maas_oam_network_ipv4_dhcp" {
  type    = bool
  default = false
}

variable "maas_oam_ipv6_network_address" {
  type    = string
  default = "none"

  validation {
    condition     = var.maas_oam_ipv6_network_address == "none" || can(cidrhost(var.maas_oam_ipv6_network_address, 1))
    error_message = "Must be 'none' or a valid IPv6 CIDR."
  }
}

variable "maas_oam_ipv6_host_address" {
  type    = string
  default = "none"

  validation {
    condition     = var.maas_oam_ipv6_host_address == "none" || can(cidrhost("${var.maas_oam_ipv6_host_address}/128", 0))
    error_message = "Must be 'none' or a valid single IPv6 address."
  }
}

variable "maas_oam_network_ipv6_nat" {
  type    = bool
  default = true
}

variable "maas_oam_ipv6_subnet_start" {
  type    = string
  default = "fd42:3959:4b5:5d92::23"

  validation {
    condition     = can(cidrhost("${var.maas_oam_ipv6_subnet_start}/128", 0))
    error_message = "Must be a valid single IPv6 address."
  }
}

variable "maas_oam_ipv6_subnet_end" {
  type    = string
  default = "fd42:3959:4b5:5d92::122"

  validation {
    condition     = can(cidrhost("${var.maas_oam_ipv6_subnet_end}/128", 0))
    error_message = "Must be a valid single IPv6 address."
  }
}

variable "maas_external_ipv4_network_address" {
  type    = string
  default = "10.251.120.1/24"

  validation {
    condition     = can(cidrhost(var.maas_external_ipv4_network_address, 1))
    error_message = "Must be a valid IPv4 CIDR (e.g., 10.251.120.1/24)."
  }
}

variable "maas_external_ipv4_host_address" {
  type    = string
  default = "10.251.120.2"

  validation {
    condition     = can(cidrhost("${var.maas_external_ipv4_host_address}/32", 0))
    error_message = "Must be a valid single IPv4 address. (e.g. 10.251.120.2)"
  }
}

variable "maas_external_ipv4_subnet_start" {
  type    = string
  default = "10.251.120.23"

  validation {
    condition     = can(cidrhost("${var.maas_external_ipv4_subnet_start}/32", 0))
    error_message = "Must be a valid single IPv4 address. (e.g. 10.251.120.23)"
  }
}

variable "maas_external_ipv4_subnet_end" {
  type    = string
  default = "10.251.120.87"

  validation {
    condition     = can(cidrhost("${var.maas_external_ipv4_subnet_end}/32", 0))
    error_message = "Must be a valid single IPv4 address. (e.g. 10.251.120.87)"
  }
}

variable "maas_external_network_ipv4_nat" {
  type    = bool
  default = true
}

variable "maas_external_network_ipv4_dhcp" {
  type    = bool
  default = false
}

### Instance Settings ###
variable "maas_instance_name" {
  type    = string
  default = "maas"

  validation {
    condition     = length(var.maas_instance_name) > 0 && length(var.maas_instance_name) <= 11
    error_message = "The maas_instance_name variable must be between 1 and 11 characters long."
  }
}

variable "maas_instance_image" {
  type    = string
  default = "ubuntu:24.04"

  validation {
    condition     = length(var.maas_instance_image) > 0
    error_message = "The maas_instance_image variable must be longer than 0 characters."
  }
}

variable "maas_cpu" {
  type    = string
  default = "2"

  validation {
    condition     = tonumber(var.maas_cpu) > 0
    error_message = "CPU must be greater than 0."
  }
}

variable "maas_memory" {
  type    = string
  default = "4GiB"

  validation {
    condition     = length(var.maas_memory) > 0
    error_message = "Memory must not be empty."
  }
}

variable "maas_disk_size" {
  type    = string
  default = "30GiB"

  validation {
    condition     = length(var.maas_disk_size) > 0
    error_message = "Disk must not be empty."
  }
}

variable "maas_instance_type" {
  type    = string
  default = "container" # alternative: "virtual-machine"

  validation {
    condition     = contains(["container", "virtual-machine"], var.maas_instance_type)
    error_message = "maas_instance_type must be either 'container' or 'virtual-machine'."
  }
}

### Extra Config ###

variable "maas_package" {
  type    = string
  default = "snap" #alternative, "deb"

  validation {
    condition     = contains(["snap", "deb"], var.maas_package)
    error_message = "maas_package must be either 'snap' or 'deb'."
  }
}

variable "maas_channel" {
  type    = string
  default = "3.5/stable"
}

variable "maas_juju_channel" {
  type    = string
  default = "3.6/stable"
}

variable "maas_image_releases" {
  type    = string
  default = "jammy" #Can be space separated series "jammy noble"

  validation {
    condition     = contains(["jammy", "noble"], var.maas_image_releases)
    error_message = "maas_image_releases contain 'jammy' or 'noble'."
  }
}

variable "maas_ipv4_dns" {
  type    = string
  default = "10.250.120.1"

  validation {
    condition     = can(cidrhost("${var.maas_ipv4_dns}/32", 0))
    error_message = "Must be a valid single IPv4 address. (e.g. 10.250.120.1)"
  }
}

variable "maas_ipv4_upstream_dns" {
  type    = string
  default = "8.8.8.8"
  
  validation {
    condition     = can(cidrhost("${var.maas_ipv4_upstream_dns}/32", 0))
    error_message = "Must be a valid single IPv4 address. (e.g. 8.8.8.8)"
  }
}

variable "maas_ipv6_dns" {
  type    = string
  default = "fd42:3959:4b5:5d92::1"

  validation {
    condition     = can(cidrhost("${var.maas_ipv6_dns}/128", 0))
    error_message = "Must be a valid single IPv6 address."
  }
}

variable "maas_ipv6_upstream_dns" {
  type    = string
  default = "2001:4860:4860::8888"

  validation {
    condition     = can(cidrhost("${var.maas_ipv6_upstream_dns}/128", 0))
    error_message = "Must be a valid single IPv6 address."
  }
}

variable "maas_user" {
  type    = string
  default = "admin"

validation {
    condition     = length(var.maas_user) >= 1 && length(var.maas_user) <= 150 && can(regex("^[a-zA-Z0-9@./+\\-_]+$", var.maas_user))
    error_message = "Username must be 150 characters or fewer and contain only letters, digits, and @/./+/-/_."
  }
}

variable "maas_password" {
  type    = string
  default = "admin"

  validation {
    condition     = length(var.maas_password) >= 1
    error_message = "Password must be at least 1 characters long."
  }
}

variable "maas_email" {
  type    = string
  default = "admin@maas-se-repros.lan"

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.maas_email))
    error_message = "Must be a valid email address."
  }
}

variable "devices" {
  description = "Map of devices to attach to the profile"
  type = map(object({
    type       = string
    properties = map(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for device in values(var.devices) :
      device.type != "" && length(device.properties) > 0
    ])
    error_message = "Each device must have a non-empty type and at least one property."
  }
}

### Profile Settings ###
variable "maas_cloud_init_file" {
  type    = string
  default = "maas-cloud-init.yaml.j2"

  validation {
    condition     = fileexists(var.maas_cloud_init_file) && can(regex("\\.yaml\\.j2$", var.maas_cloud_init_file))
    error_message = "The cloud-init file must point to an existing file and end with .yaml.j2"
  }
}

variable "extra_user_config" {
  type    = map(string)
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.extra_user_config :
      trim(k, " ") != "" && (v == null || trim(v, " ") != "")
    ])
    error_message = "All keys must be non-empty, and values must be either null or non-empty strings."
  }
}

variable "ssh_key" {
  type    = string
  default = ""

  validation {
    condition     = var.ssh_key == "" || fileexists(var.ssh_key)
    error_message = "The ssh public key file does not exist."
  }
}

variable "ssh_import_id" {
  type    = string
  default = "gh:shundezhang"

  validation {
    condition     = startswith(var.ssh_import_id, "lp:") || startswith(var.ssh_import_id, "gh:") || var.ssh_import_id == ""
    error_message = "The value must start with either \"lp:\" or \"gh:\"."
  }
}

variable "pro_token" {
  type    = string
  default = ""

  validation {
    condition     = length(var.pro_token) > 28 || var.pro_token == ""
    error_message = "An Ubuntu Pro token is greater than 28 characters long."
  }
}

variable "tail_logs" {
  description = "Whether to stream live cloud-init logs to the terminal. If false, Terraform will silently wait for cloud-init to finish natively."
  type        = bool
  default     = true
}