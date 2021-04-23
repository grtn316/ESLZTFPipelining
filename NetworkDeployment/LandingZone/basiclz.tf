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
  source = "../TFModules/networking//vnet-subnet"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vnet_name           = "vnet-${random_integer.deployment.result}"

  address_space = "10.1.0.0/16"
  default_subnet_prefix = "10.1.0.0/20"
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
