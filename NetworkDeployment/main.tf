# Resource Group for Deployment
resource "random_integer" "deployment" {
  min = 10000
  max = 99999
}

resource "azurerm_resource_group" "rg" {
  name     = "${random_integer.deployment.result}-rg"
  location = var.location
}

# Virtual Network
module "create_vnet" {
  source = "../TFModules/networking//vnet"

  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  vnet_name           = "vnet-${random_integer.deployment.result}"

  address_space = "10.111.0.0/23"
  default_subnet_prefix = "10.111.0.0/27"
  dns_servers = null
  region_zones = 1
 
}


output "rg_location" {
  value = var.location
}

output "rg_name" {
  value = azurerm_resource_group.rg.name
}

output "connectivity_vnet_name" {
    value = module.create_vnet.vnet_name
}

output "connectivity_vnet_id" {
    value = module.create_vnet.vnet_id
}

# Bastion 

module "bastion" {
  source = "../TFModules//bastion"

  subnet_cidr = "10.111.0.32/27"
  virtual_network_name = module.create_vnet.vnet_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location


}


# Deploy a Windows Server VM

module "create_windowsserver" {
  source = "../TFModules//compute"

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  vnet_subnet_id      = module.create_vnet.default_subnet_id

  tags                           = var.tags
  compute_hostname_prefix        = "server-${random_integer.deployment.result}"
  compute_instance_count         = var.compute_instance_count

  vm_size                        = var.vm_size
  os_publisher                   = var.os_publisher
  os_offer                       = var.os_offer
  os_sku                         = var.os_sku
  os_version                     = var.os_version
  storage_account_type           = var.storage_account_type
  compute_boot_volume_size_in_gb = var.compute_boot_volume_size_in_gb
  admin_username                 = var.admin_username
  admin_password                 = var.admin_password
  enable_accelerated_networking  = var.enable_accelerated_networking
  boot_diag_SA_endpoint          = var.boot_diag_SA_endpoint
  create_public_ip               = 1
  create_data_disk               = 0
  create_av_set                  = 0
  assign_bepool                 = 0
}
