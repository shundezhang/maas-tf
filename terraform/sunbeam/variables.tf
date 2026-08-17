variable "maas_provider_api_url" {
  type    = string
  default = "http://10.250.120.2:5240/MAAS"

  validation {
    condition     = length(var.maas_provider_api_url) > 0
    error_message = "The maas_provider_api_url variable must be longer than 0 characters."
  }
}