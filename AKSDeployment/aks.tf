# Data From Existing Infrastructure

data "terraform_remote_state" "existing-infra" {
  backend = "remote"

  config = {
    organization = "jcroth"

    workspaces = {
      name = "netops"
    }
  }
}

resource "random_integer" "deployment" {
  min = 10000
  max = 99999
}

module "private_aks" {
  source = "../TFmodules/aks-private"

  resource_group_name = data.terraform_remote_state.existing-infra.outputs.rg_name
  location            = data.terraform_remote_state.existing-infra.outputs.rg_location
  prefix              = "aks-${random_integer.deployment.result}"
  subnet_id = data.terraform_remote_state.existing-infra.outputs.aks_subnet_id


}

# # AKS DNS Record
# resource "azurerm_dns_a_record" "helloworld_ingress" {
#   name                = "helloworld"
#   zone_name           = data.azurerm_dns_zone.public.name
#   resource_group_name = var.resource_group_name
#   ttl                 = 300
#   records             = ["10.100.200.1"]  #IP address of Internal Ingress
# }

# Variables

# variable "tenant_id" {

# }

# variable "subscription_id" {

# }
