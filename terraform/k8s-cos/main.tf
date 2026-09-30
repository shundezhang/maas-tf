terraform {
  required_providers {
    maas = {
      source  = "canonical/maas"
      version = "~>2.0"
    }
  }
}

provider "maas" {
  api_version = "2.0"
  api_url     = var.maas_provider_api_url
  api_key     = var.maas_api_key
}

data "maas_subnet" "oam_net" {
  cidr = var.oam_subnet_cidr
}

data "maas_subnet" "ext_net" {
  cidr = var.ext_subnet_cidr
}

resource "maas_vm_host_machine" "cos" {
  hostname   = "cos-${count.index}"
  count   = var.cos_count
  vm_host = "maas-repro"
  cores   = var.cos_cpu
  memory  = var.cos_mem

  network_interfaces {
    name        = "eth0"
    subnet_cidr = data.maas_subnet.oam_net.cidr
  }

  network_interfaces {
    name        = "eth1"
    subnet_cidr = data.maas_subnet.ext_net.cidr
  }

  storage_disks {
    size_gigabytes = var.cos_disk_root
  }
  storage_disks {
    size_gigabytes = var.cos_disk_ceph
  }
}

resource "maas_tag" "cos" {
  name = "cos"
  machines = maas_vm_host_machine.cos.*.id
}