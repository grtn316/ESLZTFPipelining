output "vm_nics" {
   description = "the NIC IDs of the VMs that are created"
   value = "${concat(azurerm_network_interface.compute.*.id, azurerm_network_interface.compute_public.*.id)}" 
}