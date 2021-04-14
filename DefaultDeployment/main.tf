# Get the current client configuration from the AzureRM provider.
# This is used to populate the root_parent_id variable with the
# current Tenant ID used as the ID for the "Tenant Root Group"
# Management Group.

data "azurerm_client_config" "current" {}

# Declare the Terraform Module for Cloud Adoption Framework
# Enterprise-scale and provide a base configuration.

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "0.1.2"

  #Input Variables: https://registry.terraform.io/modules/Azure/caf-enterprise-scale/azurerm/latest?tab=inputs

  root_parent_id = var.root_parent_id #REQUIRED: The root_parent_id is used to specify where to set the root for all Landing Zone deployments. Usually the Tenant ID when deploying the core Enterprise-scale Landing Zones.
  root_id        = var.root_id   #OPTIONAL: If specified, will set a custom Name (ID) value for the Enterprise-scale "root" Management Group, and append this to the ID for all core Enterprise-scale Management Groups.
  root_name      = var.root_name #OPTIONAL: If specified, will set a custom DisplayName value for the Enterprise-scale "root" Management Group.

  archetype_config_overrides = var.archetype_config_overrides == null ? {} : var.archetype_config_overrides                               # OPTIONAL: If specified, will set custom Archetype configurations to the default Enterprise-scale Management Groups.
  create_duration_delay = var.create_duration_delay == null ? { #OPTIONAL: Used to tune terraform apply when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after creation of the specified resource type.
    azurerm_management_group      = "30s"
    azurerm_policy_assignment     = "30s"
    azurerm_policy_definition     = "30s"
    azurerm_policy_set_definition = "30s"
    azurerm_role_assignment       = "0s"
    azurerm_role_definition       = "60s"
  } : var.create_duration_delay

  custom_landing_zones      = var.custom_landing_zones == null ? false : var.custom_landing_zones           # OPTIONAL: If specified, will deploy additional Management Groups alongside Enterprise-scale core Management Groups.
  default_location          = var.default_location == null ? "eastus" : var.default_location                #OPTIONAL: If specified, will use set the default location used for resource deployments where needed.
  deploy_core_landing_zones = var.deploy_core_landing_zones == null ? true : var.deploy_core_landing_zones  #OPTIONAL: If set to true, will include the core Enterprise-scale Management Group hierarchy.
  deploy_demo_landing_zones = var.deploy_demo_landing_zones == null ? false : var.deploy_demo_landing_zones #OPTIONAL: If set to true, will include the demo "Landing Zone" Management Groups.

  destroy_duration_delay = var.destroy_duration_delay == null ? { #OPTIONAL: Used to tune terraform deploy when faced with errors caused by API caching or eventual consistency. Sets a custom delay period after destruction of the specified resource type.
    azurerm_management_group      = "0s"
    azurerm_policy_assignment     = "0s"
    azurerm_policy_definition     = "0s"
    azurerm_policy_set_definition = "0s"
    azurerm_role_assignment       = "0s"
    azurerm_role_definition       = "0s"
  } : var.destroy_duration_delay

  library_path = var.library_path == null ? "" : var.library_path #OPTIONAL: If specified, sets the path to a custom library folder for archetype artefacts.

  subscription_id_overrides = var.subscription_id_overrides == null ? {} : var.subscription_id_overrides #OPTIONAL: If specified, will be used to assign subscription_ids to the default Enterprise-scale Management Groups.
  template_file_variables   = var.template_file_variables == null ? {} : var.template_file_variables     #OPTIONAL: If specified, provides the ability to define custom template variables used when reading in template files from the built-in and custom library_path.
}
