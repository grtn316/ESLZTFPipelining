
resource "azurerm_kubernetes_cluster" "private" {
  name                = "${var.prefix}-k8s"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.prefix}-k8s"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
    enable_auto_scaling = true
    min_count = 1
    max_count = 3    
    type = "VirtualMachineScaleSets"
    vnet_subnet_id = var.subnet_id
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    load_balancer_sku = "standard"
    service_cidr       = "10.200.0.0/16"
    dns_service_ip     = "10.200.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    # pod_cidr = "10.244.0.0/16" (needed with Kubenet)
  }


  identity {
    type = "UserAssigned"
    user_assigned_identity_id = "/subscriptions/0fd3a867-7211-409f-9678-9b812ed9aa47/resourcegroups/64729-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/aksnetcontrib"
  }

  # linux_profile {
  #   admin_username = "sysadmin"

  #   ssh_key {
  #     key_data = "~/.ssh/id_rsa.pub"
  #   }

  # }

  # windows_profile {
  #   admin_username = "sysadmin"
  #   admin_password = "P@ssw0rd12345!!"
  # }

  # private_cluster_enabled = true

}

resource "azurerm_role_assignment" "aks" {
  principal_id         = azurerm_kubernetes_cluster.private.identity[0].principal_id
  role_definition_name = "Network Contributor"
  scope                = var.subnet_id # Subnet ID
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.private.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.private.kube_config_raw
}