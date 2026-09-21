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

resource "maas_subnet_ip_range" "oam_reserved_internal" {
  subnet   = data.maas_subnet.oam_net.id
  type     = "reserved"
  start_ip = cidrhost(var.oam_subnet_cidr, var.internal_api_range_lower)   # e.g. .10
  end_ip   = cidrhost(var.oam_subnet_cidr, var.internal_api_range_upper)   # e.g. .50
  comment  = "${var.cloud_name}-internal-api"
}

resource "maas_subnet_ip_range" "oam_reserved_public" {
  subnet   = data.maas_subnet.oam_net.id
  type     = "reserved"
  start_ip = cidrhost(var.oam_subnet_cidr, var.public_api_range_lower)   # e.g. .10
  end_ip   = cidrhost(var.oam_subnet_cidr, var.public_api_range_upper)   # e.g. .50
  comment  = "${var.cloud_name}-public-api"
}

resource "maas_vm_host_machine" "juju_controller" {
  hostname   = "juju-controller-${count.index}"
  count   = var.juju_controller_count
  vm_host = "maas-repro"
  cores   = var.juju_controller_cpu
  memory  = var.juju_controller_mem

  storage_disks {
    size_gigabytes = var.juju_controller_disk
  }
}

resource "maas_tag" "juju_controller" {
  name = "juju-controller"
  machines = maas_vm_host_machine.juju_controller.*.id
}

resource "maas_vm_host_machine" "sunbeam_controller" {
  hostname   = "sunbeam-controller-${count.index}"
  count   = var.sunbeam_controller_count
  vm_host = "maas-repro"
  cores   = var.sunbeam_controller_cpu
  memory  = var.sunbeam_controller_mem

  storage_disks {
    size_gigabytes = var.sunbeam_controller_disk
  }
}

resource "maas_tag" "sunbeam_controller" {
  name = "sunbeam"
  machines = maas_vm_host_machine.sunbeam_controller.*.id
}

resource "maas_vm_host_machine" "cloud" {
  hostname   = "cloud-${count.index}"
  count   = var.cloud_count
  vm_host = "maas-repro"
  cores   = var.cloud_cpu
  memory  = var.cloud_mem

  network_interfaces {
    name        = "eth0"
    subnet_cidr = data.maas_subnet.oam_net.cidr
  }

  network_interfaces {
    name        = "eth1"
    subnet_cidr = data.maas_subnet.ext_net.cidr
  }

  storage_disks {
    size_gigabytes = var.cloud_disk_root
  }
  storage_disks {
    size_gigabytes = var.cloud_disk_ceph
  }
}

resource "maas_tag" "openstack_cloud" {
  name = "openstack-${var.cloud_name}"
  machines = concat(
    maas_vm_host_machine.juju_controller[*].id,
    maas_vm_host_machine.sunbeam_controller[*].id,
    maas_vm_host_machine.cloud[*].id,
  )
}

# Tag the second disk (sdb / 100GB) on each of the 3 machines
# resource "maas_block_device" "cloud_second_disk" {
#   count          = var.cloud_count
#   machine        = maas_vm_host_machine.cloud[count.index].id
#   name           = "sdb"                 # second disk
#   id_path        = "/dev/sdb"
#   size_gigabytes = 100

#   tags = ["ceph"]
# }

data "maas_machine" "cloud_machine" {
  count      = var.cloud_count
  hostname   = maas_vm_host_machine.cloud[count.index].hostname
  depends_on = [maas_vm_host_machine.cloud]
}

resource "maas_block_device_tag" "cloud_sdb" {
  machine         = maas_vm_host_machine.cloud[count.index].id
  block_device_id = data.maas_machine.cloud_machine[count.index].block_devices[1].id
  tags = [
    "ceph",
  ]
  count = var.cloud_count
}


# Tag the second interface (eth1) on each of the 3 machines
# resource "maas_network_interface_physical" "eth1_tag" {
#   count   = var.cloud_count
#   machine = maas_vm_host_machine.cloud[count.index].id
#   name    = "eth1"                       # the second interface, already created above
#   tags    = ["neutron:physnet1"]        # <-- your tags on eth1
# }

data "maas_network_interface_physical" "cloud_eth1" {
  count   = var.cloud_count
  machine = maas_vm_host_machine.cloud[count.index].id
  name    = "eth1"
}

resource "maas_network_interface_tag" "cloud_eth1" {
  count        = var.cloud_count
  machine      = maas_vm_host_machine.cloud[count.index].id
  interface_id = data.maas_network_interface_physical.cloud_eth1[count.index].id
  tags         = ["neutron:physnet1"]
}

resource "maas_network_interface_link" "eth1_unconfigured" {
  count             = var.cloud_count
  machine           = maas_vm_host_machine.cloud[count.index].id
  network_interface = maas_vm_host_machine.cloud[count.index].network_interfaces[1].id
  subnet            = data.maas_subnet.ext_net.id
  mode              = "LINK_UP" # Connects interface to subnet without allocating an IP
}

resource "maas_tag" "control" {
  name = "control"
  machines = maas_vm_host_machine.cloud.*.id
}

resource "maas_tag" "compute" {
  name = "compute"
  machines = maas_vm_host_machine.cloud.*.id
}

resource "maas_tag" "storage" {
  name = "storage"
  machines = maas_vm_host_machine.cloud.*.id
}