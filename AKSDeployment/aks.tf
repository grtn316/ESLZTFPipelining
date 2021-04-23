# Data From Existing Infrastructure

data "terraform_remote_state" "existing-lz" {
  backend = "remote"

  config = {
    organization = "jcroth"

    workspaces = {
      name = "lza1"
    }
  }
}

resource "random_integer" "deployment" {
  min = 10000
  max = 99999
}


resource "azurerm_resource_group" "rg" {
  name     = "${random_integer.deployment.result}-aks-rg"
  location = data.terraform_remote_state.existing-lz.outputs.rg_location
}


module "private_aks" {
  source = "../TFModules//aks-private"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  prefix              = "aks-${random_integer.deployment.result}"
  subnet_id = data.terraform_remote_state.existing-lz.outputs.lz_default_subnet_id


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
