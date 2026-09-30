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

variable "cos_cpu" {
  type    = number
  default = 4

  validation {
    condition     = var.cos_cpu > 0
    error_message = "CPU must be greater than 0."
  }
}

variable "cos_mem" {
  type    = number
  default = 8192

  validation {
    condition     = var.cos_mem > 0
    error_message = "Memory must be greater than 0."
  }
}

variable "cos_disk_root" {
  type    = number
  default = 20

  validation {
    condition     = var.cos_disk_root > 0
    error_message = "Disk size must be greater than 0."
  }
}

variable "cos_disk_ceph" {
  type    = number
  default = 30

  validation {
    condition     = var.cos_disk_ceph > 0
    error_message = "Disk size must be greater than 0."
  }
}

variable "cos_count" {
  type    = number
  default = 3

  validation {
    condition     = var.cos_count > 0
    error_message = "cos_count must be greater than 0."
  }
}