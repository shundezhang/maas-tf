terraform {
  required_providers {
    maas = {
      source  = "canonical/maas"
      version = "2.4.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.3.3"
    }
  }
}
