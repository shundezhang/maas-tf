terraform {
  required_providers {
    lxd = {
      source  = "terraform-lxd/lxd"
      version = "> 3.0.0"
    }
  }
}

provider "lxd" {
  remote {
    name    = "local"
    address = "unix://"
  }
}

### Project Configuration ###
resource "lxd_project" "maas_project" {
  name        = "maas-repro"
  description = "LXD Project for maas reproducer"
  # Share networks, storage pools, and volumes from default with this project, but separate images and profiles
  config = {
    "features.images"          = false
    "features.networks"        = false
    "features.profiles"        = true
    "features.storage.volumes" = false
  }
}

### Network Configuration ###
resource "lxd_network" "maas_oam" {
  # Network name with a case_id or random case_id appended
  name = "maas-oam"
  project = "maas-repro"
  description = "MAAS OAM network"

  # depends_on helps with correctly creating and destroying resources in order
  depends_on = [
    lxd_project.maas_project
  ]

  config = {
    "ipv4.address" = var.maas_oam_ipv4_network_address
    "ipv4.nat"     = var.maas_oam_network_ipv4_nat
    "ipv4.dhcp"    = var.maas_oam_network_ipv4_dhcp
    "ipv6.address" = var.maas_oam_ipv6_network_address
    "ipv6.nat"     = var.maas_oam_network_ipv6_nat
    # "dns.domain"   = "${var.maas_id}"
    # "dns.search"   = "${var.maas_id}"
  }
}

resource "lxd_network" "maas_external" {
  # Network name with a case_id or random case_id appended
  name = "maas-external"
  project = "maas-repro"
  description = "MAAS External network"

  # depends_on helps with correctly creating and destroying resources in order
  depends_on = [
    lxd_project.maas_project
  ]

  config = {
    "ipv4.address" = var.maas_external_ipv4_network_address
    "ipv4.nat"     = var.maas_external_network_ipv4_nat
    "ipv4.dhcp"    = var.maas_external_network_ipv4_dhcp
    # "ipv6.address" = var.maas_external_ipv6_network_address
    # "ipv6.nat"     = var.maas_external_network_ipv6_nat
    # "dns.domain"   = "${var.maas_id}"
    # "dns.search"   = "${var.maas_id}"
  }
}

resource "lxd_profile" "maas_profile" {
  name        = var.maas_profile_name
  description = "Default Profile for maas"
  # Project name with a case_id or random case_id appended
  project = lxd_project.maas_project.name

  # depends_on helps with correctly creating and destroying resources in order
  depends_on = [
    lxd_project.maas_project,
    lxd_trust_certificate.maas_controller_cert
  ]



  # dynamic "device" {
  #   for_each = var.devices
  #   content {
  #     name       = device.key
  #     type       = device.value.type
  #     properties = device.value.properties
  #   }
  # }
}

# Generate a private key
resource "tls_private_key" "maas_lxd_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Generate a self-signed certificate
resource "tls_self_signed_cert" "maas_lxd_cert" {
  private_key_pem = tls_private_key.maas_lxd_key.private_key_pem

  subject {
    common_name  = "maas-repro-client"
    organization = "MAAS Reproducer"
  }

  validity_period_hours = 8760 # 1 year
  early_renewal_hours   = 24
  allowed_uses          = [ "client_auth" ]
}

# Add certificate to LXD server trust store
resource "lxd_trust_certificate" "maas_controller_cert" {
  name        = "maas_controller_cert"
  content     = tls_self_signed_cert.maas_lxd_cert.cert_pem
  type        = "client"
  projects    = [ lxd_project.maas_project.name ]
}

resource "lxd_instance" "maas_instance" {

  # depends_on helps with correctly creating and destroying resources in order
  depends_on = [
    lxd_profile.maas_profile,
    lxd_network.maas_oam,
    lxd_network.maas_external
  ]

  name = var.maas_instance_name
  # Project name with a case_id or random case_id appended
  project = lxd_project.maas_project.name
  # If needed multple profiles can be used as shown below.
  # Note the name of the profile created above is referenced here
  profiles = [lxd_profile.maas_profile.name]
  image    = var.maas_instance_image
  # Here the type of the instance is set to either "container" or"virtual-machine" by the
  # variable defined at the top of this file.
  type = var.maas_instance_type

  # Terraform will wait up to the time set below for an instance to create.
  timeouts = {
    create = "60m"
  }

  # The config var is a combination/merge of the default map shown below and an extra reproducer specific defined map.
  config = merge(
    {
      "limits.cpu"    = var.maas_cpu
      "limits.memory" = var.maas_memory

      "cloud-init.user-data" = file(var.maas_cloud_init_file)
      # If the values below are set and sourced from conf.env (local copy of template.env) they will be
      # passed over to the cloud-init file above to be parsed by jinja. These user settings
      # have defaults set in `variables.tf` as they are used in other reproducers.
      "user.ssh_key"       = var.ssh_key == "" ? null : (endswith(var.ssh_key, ".pub") ? trimsuffix(file(var.ssh_key), "\n") : trimsuffix(file(format("%s.pub", var.ssh_key)), "\n"))
      "user.ssh_import_id" = var.ssh_import_id != "" ? var.ssh_import_id : null
      "user.user"          = var.maas_user
      "user.password"      = var.maas_password
      "user.pro_token"     = var.pro_token == "" ? null : var.pro_token

      "user.maas_package" = var.maas_package
      "user.maas_channel" = var.maas_channel
      "user.maas_juju_channel" = var.maas_juju_channel
      "user.maas_image_releases" = var.maas_image_releases
      "user.maas_ipv4_dns" = var.maas_ipv4_dns
      "user.maas_ipv4_host_address" = var.maas_oam_ipv4_host_address
      "user.maas_ipv4_network_address" = var.maas_oam_ipv4_network_address
      "user.maas_ipv4_upstream_dns" = var.maas_ipv4_upstream_dns
      "user.maas_ipv4_subnet_start" = var.maas_oam_ipv4_subnet_start
      "user.maas_ipv4_subnet_end" = var.maas_oam_ipv4_subnet_end
      "user.maas_ipv6_dns" = var.maas_ipv6_dns
      "user.maas_ipv6_upstream_dns" = var.maas_ipv6_upstream_dns
      "user.maas_ipv6_subnet_start" = var.maas_oam_ipv6_subnet_start
      "user.maas_ipv6_subnet_end" = var.maas_oam_ipv6_subnet_end
      "user.maas_ipv4_ext_network_address" = var.maas_external_ipv4_network_address
      "user.maas_ipv4_ext_host_address" = var.maas_external_ipv4_host_address
      "user.maas_user" = var.maas_user
      "user.maas_password" = var.maas_password
      "user.maas_email" = var.maas_email
      "user.maas_project_name" = lxd_project.maas_project.name
      "user.maas_client_cert" = tls_self_signed_cert.maas_lxd_cert.cert_pem
      "user.maas_client_key"  = tls_private_key.maas_lxd_key.private_key_pem
    },
    # These extra user configs are set per reproducer, see microk8s.tf as an example.
    var.extra_user_config
  )

  device {
    name = "eth0" 
    type = "nic"
    properties = {
      network = lxd_network.maas_oam.name
      "ipv4.address" = var.maas_oam_ipv4_host_address
    }
  }

  device {
    name = "eth1" 
    type = "nic"
    properties = {
      network = lxd_network.maas_external.name
      # "ipv4.address" = var.maas_external_ipv4_host_address
    }
  }

  device {
    name = "root"
    type = "disk"
    properties = {
      pool = var.storage_name
      path = "/"
      size = var.maas_disk_size
    }
  }

  # Terraform will wait for cloud-init to complete and be "done". If the cloud-init for this
  # instance gets an error Terraform will print the issue to the console and the user may
  # want to inspect the cloud-init logs in the instance.
  execs = {
    "wait_cloud_init" = {
      command       = ["cloud-init", "status", "--wait"]
      enabled       = !var.tail_logs
      trigger       = "once"
      record_output = true
      fail_on_error = true
    }
  }
}

### Log Tailing Trigger ###
# resource "terraform_data" "tail_cloud_init_logs" {
#   # Only create this resource if tail_logs is true
#   count = var.tail_logs ? 1 : 0

#   depends_on = [
#     lxd_instance.maas_instance
#   ]

#   provisioner "local-exec" {
#     command = "${path.module}/../../../../tools/terraform-scripts/tail-logs.sh ${lxd_instance.maas_instance.name} ${nonsensitive(lxd_instance.maas_instance.project)}"
#   }
# }