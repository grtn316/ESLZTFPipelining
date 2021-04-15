resource "azurerm_network_security_group" "nsg" {
  name            = "${var.vnet_name}-default-nsg" 
  resource_group_name = var.resource_group_name
  location            = var.location

  # tags = var.tags
}


resource "azurerm_virtual_network" "vnet" {
  name                 = "default"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.vnet_name
  address_space       = [var.address_space] 
  dns_servers         = var.dns_servers
  tags                = var.tags

  subnet {
    name           = "default"
    address_prefix = [var.default_subnet_prefix]
    security_group = azurerm_network_security_group.nsg.id
  }

}


variable "resource_group_name" {
}

variable "location" {

}


variable "vnet_name" {
}

variable "address_space" {
}

variable "default_subnet_prefix"  {

}

variable "dns_servers" {
  
}

# variable "ddos_plan_id" {

# }

variable "region_zones" {
  
}


output "vnet_name" {
    value = azurerm_virtual_network.vnet.name
}

output "vnet_id" {
    value = azurerm_virtual_network.vnet.id
}

output "vnet_rg" {
    value = azurerm_virtual_network.vnet.resource_group_name
}

output "vnet_location" {
    value = azurerm_virtual_network.vnet.location
}

output "default_subnet_id" {
  value = azurerm_virtual_network.vnet.subnet.id

}

output "default_subnet_name" {
  #value = "azurerm_subnet.vnet.name"
  value = azurerm_virtual_network.vnet.subnet.name
}

output "defaultsub_nsg_name" {
    value = azurerm_network_security_group.nsg.name
}

# This output is here (not in the output file) because
# it is needed to pass the zone info through to the VM deployment module. 
output "zones" {
    value = var.region_zones
}


