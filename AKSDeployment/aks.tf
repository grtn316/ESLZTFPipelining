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
  private = false


}

resource "azurerm_container_registry" "acr" {
  name                     = "acr${random_integer.deployment.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Premium"
  admin_enabled            = true
}


output "client_certificate" {
  value = module.private_aks.client_certificate
}

output "kube_config" {
  value = module.private_aks.kube_config
}

# output "lb_pip" {
#   value = module.private_aks.lb_pip

# }