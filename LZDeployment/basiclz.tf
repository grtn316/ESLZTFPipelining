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


resource "azurerm_resource_group" "rg" {
  name     = "${random_integer.deployment.result}-rg"
  location = data.terraform_remote_state.existing-infra.outputs.rg_location
}

# Virtual Network
module "create_vnet" {
  source = "../TFModules/networking//vnet"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vnet_name           = "vnet-${random_integer.deployment.result}"

  address_space = "100.111.2.0/23"
  default_subnet_prefix = "100.111.2.0/27"
  dns_servers = null
  region_zones = 1

}

module "peering" {
  source = "../TFModules/networking//peering"

  resource_group_nameA = azurerm_resource_group.rg.name
  netA_name            = module.create_vnet.vnet_name  
  netA_id              = module.create_vnet.vnet_id
  resource_group_nameB = data.terraform_remote_state.existing-infra.outputs.rg_name
  netB_name            = data.terraform_remote_state.existing-infra.outputs.connectivity_vnet_name
  netB_id              = data.terraform_remote_state.existing-infra.outputs.connectivity_vnet_id

}

module "peering2" {
  source = "../TFModules/networking//peering"
  providers = {azurerm = azurerm.connectivity}

  
  resource_group_nameA = data.terraform_remote_state.existing-infra.outputs.rg_name
  netA_name            = data.terraform_remote_state.existing-infra.outputs.connectivity_vnet_name
  netA_id              = data.terraform_remote_state.existing-infra.outputs.connectivity_vnet_id
  resource_group_nameB = azurerm_resource_group.rg.name
  netB_name            = module.create_vnet.vnet_name  
  netB_id              = module.create_vnet.vnet_id


}


output "rg_location" {
  value = var.location
}

output "rg_name" {
  value = azurerm_resource_group.rg.name
}

output "lz_vnet_name" {
    value = module.create_vnet.vnet_name
}

output "lz_vnet_id" {
    value = module.create_vnet.vnet_id
}

output "lz_default_subnet_id" {
  value = module.create_vnet.default_subnet_id
}