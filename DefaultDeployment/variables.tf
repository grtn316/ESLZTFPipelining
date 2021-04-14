# Use variables to customise the deployment

variable "root_parent_id" {
  type    = string
  default = data.azurerm_client_config.current.tenant_id
}

variable "root_id" {
  type    = string
  default = "RootId"
}

variable "root_name" {
  type    = string
  default = "Tenant Root Group"
}

variable "archetype_config_overrides" {
  type    = map(any)
  default = {}
}

variable "create_duration_delay" {
  type    = map(string)
  default = {
                azurerm_management_group      = "30s"
                azurerm_policy_assignment     = "30s"
                azurerm_policy_definition     = "30s"
                azurerm_policy_set_definition = "30s"
                azurerm_role_assignment       = "0s"
                azurerm_role_definition       = "60s"
            }
}

variable "custom_landing_zones" {
  type    = map( object({ display_name = string, parent_management_group_id = string, subscription_ids = list(string), archetype_config = object({ archetype_id = string, parameters = any, access_control = any }) }) )
  default = {}
}

variable "default_location" {
  type    = string
  default = "eastus"
}

variable "deploy_core_landing_zones" {
  type    = bool
  default = true
}

variable "deploy_demo_landing_zones" {
  type    = bool
  default = false
}

variable "destroy_duration_delay" {
  type    = map(string)
  default = {
                azurerm_management_group      = "0s"
                azurerm_policy_assignment     = "0s"
                azurerm_policy_definition     = "0s"
                azurerm_policy_set_definition = "0s"
                azurerm_role_assignment       = "0s"
                azurerm_role_definition       = "0s"
            }
}

variable "library_path" {
  type    = string
  default = ""
}

variable "subscription_id_overrides" {
  type    = map(list(string))
  default = {}
}

variable "template_file_variables" {
  type    = map(any)
  default = {}
}