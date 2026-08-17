terraform {
  required_providers {
    maas = {
      source  = "canonical/maas"
      version = "~>2.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "2.3.3"
    }
  }
}

provider "external" {}


data "external" "maas_apikey" {
  program = ["bash", "-c", "echo \"{\\\"apikey\\\": \\\"$(lxc exec maas --project se-repros -- maas apikey --username admin)\\\"}\""]
}


provider "maas" {
  api_version = "2.0"
  api_url     = var.maas_provider_api_url
  api_key     = data.external.maas_apikey.result.apikey
  depends_on = [data.external.maas_apikey]
}

