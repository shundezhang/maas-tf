variable "maas_provider_api_url" {
  type    = string
  default = "http://10.250.120.2:5240/MAAS"

  validation {
    condition     = length(var.maas_provider_api_url) > 0
    error_message = "The maas_provider_api_url variable must be longer than 0 characters."
  }
}

variable "maas_api_key" {
  type    = string
  default = ""

  validation {
    condition     = length(var.maas_api_key) > 0
    error_message = "The maas_api_key variable must be longer than 0 characters."
  }
}

variable "cloud_name" {
  type    = string
  default = "mycloud"

  validation {
    condition     = length(var.cloud_name) > 0
    error_message = "The cloud_name variable must be longer than 0 characters."
  }
}

variable "internal_api_range_lower" {
  type    = number
  default = 101

  validation {
    condition     = var.internal_api_range_lower > 0
    error_message = "internal_api_range_lower must be greater than 0."
  }
}

variable "internal_api_range_upper" {
  type    = number
  default = 140

  validation {
    condition     = var.internal_api_range_upper > 0
    error_message = "internal_api_range_upper must be greater than 0."
  }
}

variable "public_api_range_lower" {
  type    = number
  default = 141

  validation {
    condition     = var.public_api_range_lower > 0
    error_message = "public_api_range_lower must be greater than 0."
  }
}

variable "public_api_range_upper" {
  type    = number
  default = 180

  validation {
    condition     = var.public_api_range_upper > 0
    error_message = "public_api_range_upper must be greater than 0."
  }
}

variable "juju_controller_cpu" {
  type    = number
  default = 2

  validation {
    condition     = var.juju_controller_cpu > 0
    error_message = "CPU must be greater than 0."
  }
}

variable "juju_controller_mem" {
  type    = number
  default = 4096

  validation {
    condition     = var.juju_controller_mem > 0
    error_message = "Memory must be greater than 0."
  }
}

variable "juju_controller_disk" {
  type    = number
  default = 30

  validation {
    condition     = var.juju_controller_disk > 0
    error_message = "Disk size must be greater than 0."
  }
}
variable "sunbeam_controller_cpu" {
  type    = number
  default = 1

  validation {
    condition     = var.sunbeam_controller_cpu > 0
    error_message = "CPU must be greater than 0."
  }
}

variable "sunbeam_controller_mem" {
  type    = number
  default = 2048

  validation {
    condition     = var.sunbeam_controller_mem > 0
    error_message = "Memory must be greater than 0."
  }
}

variable "sunbeam_controller_disk" {
  type    = number
  default = 30

  validation {
    condition     = var.sunbeam_controller_disk > 0
    error_message = "Disk size must be greater than 0."
  }
}

variable "cloud_cpu" {
  type    = number
  default = 12

  validation {
    condition     = var.cloud_cpu > 0
    error_message = "CPU must be greater than 0."
  }
}

variable "cloud_mem" {
  type    = number
  default = 49152

  validation {
    condition     = var.cloud_mem > 0
    error_message = "Memory must be greater than 0."
  }
}

variable "cloud_disk_root" {
  type    = number
  default = 150

  validation {
    condition     = var.cloud_disk_root > 0
    error_message = "Disk size must be greater than 0."
  }
}

variable "cloud_disk_ceph" {
  type    = number
  default = 100

  validation {
    condition     = var.cloud_disk_ceph > 0
    error_message = "Disk size must be greater than 0."
  }
}


variable "oam_subnet_cidr" {
  type    = string
  default = "10.250.120.0/24"

  validation {
    condition     = length(var.oam_subnet_cidr) > 0
    error_message = "The oam_subnet_cidr variable must be longer than 0 characters."
  }
}

variable "ext_subnet_cidr" {
  type    = string
  default = "10.251.120.0/24"

  validation {
    condition     = length(var.ext_subnet_cidr) > 0
    error_message = "The ext_subnet_cidr variable must be longer than 0 characters."
  }
}

variable "juju_controller_count" {
  type    = number
  default = 1

  validation {
    condition     = var.juju_controller_count > 0
    error_message = "juju_controller_count must be greater than 0."
  }
}

variable "sunbeam_controller_count" {
  type    = number
  default = 1

  validation {
    condition     = var.sunbeam_controller_count > 0
    error_message = "sunbeam_controller_count must be greater than 0."
  }
}

variable "cloud_count" {
  type    = number
  default = 3

  validation {
    condition     = var.cloud_count > 0
    error_message = "cloud_count must be greater than 0."
  }
}
