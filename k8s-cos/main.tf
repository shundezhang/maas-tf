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

provider "maas" {
  api_version = "2.0"
  api_url     = var.maas_provider_api_url
  api_key     = var.maas_provider_api_key
}

provider "external" {}

